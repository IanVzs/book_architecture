没啥好说的, 直接看代码: 
```python
import os
import gzip
import shutil
import paramiko
import multiprocessing
from pathlib import Path
from loguru import logger

from config import globalconf

class SSHConnection(object):
    def __init__(self, host=None, port=None, username=None, pwd=None, pk_path=None):
        """
        :param host: 服务器ip
        :param port: 接口
        :param username: 登录名
        :param pwd: 密码
        """
        self.host = host
        self.port = port
        self.username = username
        self.pwd = pwd
        self.pk_path = pk_path

    def __enter__(self):
        self.connect()
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.close()
        return True

    def connect(self):
        transport = paramiko.Transport((self.host, self.port))
        # transport.connect(username=self.username, password=self.pwd)
        pk = paramiko.RSAKey.from_private_key_file(self.pk_path)
        transport.connect(username=self.username, pkey=pk)
        self.__transport = transport
        self.sftp = paramiko.SFTPClient.from_transport(self.__transport)
  
    def close(self):
        self.__transport.close()
        self.sftp.close()

    def upload(self, local_path, target_path):
        self.sftp.put(local_path, target_path)

    def download(self, remote_path, local_path):
        sftp = paramiko.SFTPClient.from_transport(self.__transport)
        sftp.get(remote_path, local_path)

    def listdir(self, path):
        return self.sftp.listdir(path=path)

    def listdir_attr(self, path):
        return self.sftp.listdir_attr(path=path)


    def download_slowly(self, remote_path, local_path):
        sftp = paramiko.SFTPClient.from_transport(self.__transport)
  

        # # 旧方法下载大文件会出现Server connection dropped
        # sftp.get(remote_path, local_path)

        # 新方法下载大文件成功
        # 这将避免Paramiko预取缓存，并允许您下载文件，即使它不是很快
        with sftp.open(remote_path, 'rb') as fp:
            shutil.copyfileobj(fp, open(local_path, 'wb'))


    def cmd(self, command):
        ssh = paramiko.SSHClient()
        # 执行命令
        stdin, stdout, stderr = ssh.exec_command(command)
        # 获取命令结果
        result = stdout.read()
        result = str(result, encoding='utf-8')
        return result
  

class SSHConnectionManager(object):
    def __init__(self, host, port, username, pwd, pk_path):
        self.ssh_args = {
            "host": host,
            "port": port,
            "username": username,
            "pk_path": pk_path,
            "pwd": pwd
        }
    def __enter__(self):
        self.ssh = SSHConnection(**self.ssh_args)
        self.ssh.connect()
        return self.ssh
  
    def __exit__(self, exc_type, exc_val, exc_tb):
        self.ssh.close()
        return True


def clear_dir(path):
    """
    清空文件夹：如果文件夹不存在就创建，如果文件存在就清空！
    :param path: 文件夹路径
    :return:
    """
    import os
    import shutil
    try:
        if not os.path.exists(path):
            os.makedirs(path)
        else:
            shutil.rmtree(path)
            os.makedirs(path)
        return True
    except:
        return False

def decompress_gz(gz_file):
    with gzip.GzipFile(gz_file) as file:
        for i in file:
            yield i
  

def get_file_sftp(tar_path):
    temp_path = os.path.join(globalconf.SFTP_TEMP_PATH, os.path.split(tar_path)[-1])
    try:
        with SSHConnection(
            host=globalconf.SFTP_SERVER_HOST,
            port=globalconf.SFTP_SERVER_PORT,
            username=globalconf.SFTP_USERNAME,
            pwd="",
            pk_path=globalconf.SFTP_KEY_PATH
        ) as sftp:
            sftp.download_slowly(tar_path, temp_path)
    except Exception as err:
        logger.error(f"sftp 下载文件出错: {err}")
    return temp_path
  

def format_file_list(file_list):
    root_dir = os.path.dirname(file_list[0])
    sub_files = set([os.path.basename(file) for file in file_list])
    return root_dir, sub_files
  

def is_sftp_file_exists(task_id, path):
    exists = False
    if isinstance(path, str) and path:
        path = [path]
    rootdir, _ = format_file_list(path)
    try:
        with SSHConnection(
            host=globalconf.SFTP_SERVER_HOST,
            port=globalconf.SFTP_SERVER_PORT,
            username=globalconf.SFTP_USERNAME,
            pwd="",
            pk_path=globalconf.SFTP_KEY_PATH
        ) as sftp:
            list_file_names = sftp.listdir(rootdir)
            if str(task_id) in str(list_file_names):
                exists = True
    except Exception as err:
        logger.error(f"sftp 获取文件列表错误: {err}")
    return exists
  

class SFTPFileManager_Tool(object):
    def __init__(self, host, port, username, pwd, pk_path):
        """
        init
        :param host:        ip
        :param port:        端口
        :param username:    用户名
        :param pwd:         密码
        """
        self.ssh_args = {"host": host, "port": port, "username": username, "pwd": pwd, "pk_path": pk_path}
  

    def exists(self, path):
        """
        判断路径是否存在
        :param path:
        :return:
        """
        is_exists = False
        with SSHConnectionManager(**self.ssh_args) as ssh:
            result = ssh.cmd(f"find {path}")
            if result:
                is_exists = True
        return is_exists
  

    def is_file(self, path):
        """
        判断路径是否是文件
        :param path:
        :return:
        """
        if self.exists(path):
            with SSHConnectionManager(**self.ssh_args) as ssh:
                prefix = ssh.cmd(f"ls -ld {path}")[0]
                if prefix == '-':
                    return True
                else:
                    return False
        else:
            return False
  

    def is_dir(self, path):
        """
        判断路径是否是目录
        :param path:
        :return:
        """
        if self.exists(path):
            with SSHConnectionManager(**self.ssh_args) as ssh:
                prefix = ssh.cmd(f"ls -ld {path}")[0]
                if prefix == 'd':
                    return True
                else:
                    return False
        else:
            return False

    def download_file(self, remote_path, local_path):
        """
        下载文件
        :param remote_path: 远程文件路径
        :param local_path:  本地文件路径
        :return:
        """
        print(f"正下载文件{remote_path}...")
        with SSHConnectionManager(**self.ssh_args) as ssh:
            if not Path(local_path).parent.exists():
                Path(local_path).parent.mkdir(parents=True)
            ssh.download_slowly(remote_path=remote_path, local_path=local_path)
  

    def download_folder(self, remote_folder, local_folder):
        """
        下载文件夹
        :param remote_folder:   远程文件夹目录
        :param local_folder:    本地文件夹目录
        :return:
        """
        with SSHConnectionManager(**self.ssh_args) as ssh:
            dst_folder = Path(local_folder)
            if not dst_folder.exists():
                dst_folder.mkdir(parents=True)
            clear_dir(str(dst_folder))
            files_list = ssh.cmd("ls {}".format(remote_folder))
            files_list = files_list.split('\n')
            files_list = [x for x in files_list if x]

            # 多进程下载文件
            cpu_count = multiprocessing.cpu_count() // 2
            if cpu_count == 0:
                cpu_count = 1
            pool = multiprocessing.Pool(cpu_count)
            for file in files_list:
                remote_path = remote_folder + "/" + file
                local_path = dst_folder.joinpath(file)
                pool.apply_async(func=self.download_file, args=(remote_path, local_path))
            pool.close()
            pool.join()


            # 主进程下载文件
            # for file in files_list:
            #     remote_path = remote_folder + "/" + file
            #     local_path = dst_folder.joinpath(file)
            #     print(f"正下载{remote_path}...")
            #     ssh.download_slowly(remote_path=remote_path, local_path=local_path)
if __name__ == "__main__":
    a = SFTPFileManager_Tool(host="1.1.1.1", port=5050, username="sftpuser", pwd="", pk_path="/root/.ssh/id_rsa")
    b = a.is_dir("/hello/")
    print(b)
```