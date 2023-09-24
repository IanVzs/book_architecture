---
title: 解决问题
date: 2021-05-023 10:30:41
categories: [tip, problem]
tags: [win, git]
---
![问题们](https://tse2-mm.cn.bing.net/th/id/OIP.Z6kn8Zh9FDU2oe4r5ceCgAHaEK?pid=ImgDet&rs=1 "Problem")
# 各种一键问题解决方案
## Windows下Git问题
- Linux没啥问题,但在Win下报checkout失败,路径问题
```bash
git config core.protectNTFS false
```

## docker - supervisord 禁用日志文件或使用 logfile=/dev/stdout

from: https://www.coder.work/article/100835
标签 [docker](https://www.coder.work/blog?tag=docker "docker") [supervisord](https://www.coder.work/blog?tag=supervisord "supervisord")

```supervisor
[supervisord]
nodaemon=true
logfile=/dev/stdout
pidfile=/var/run/supervisord.pid
childlogdir=/var/log/supervisor
```

当我这样做时，这个主管会崩溃，因为它无法在/dev/stdout 中寻找

如何禁用 supervisord 在我的 docker 容器中创建任何日志文件？

**最佳答案**

对于主主管，`nodaemon` 将导致日志转到 `stdout`

```supervisor
[supervisord]
nodaemon=true
logfile=/dev/null
logfile_maxbytes=0
```

然后将每个托管进程的日志发送到标准输出文件描述符`/dev/fd/1`

```supervisor
[program:x]
command=echo test
stdout_logfile=/dev/fd/1
stdout_logfile_maxbytes=0
redirect_stderr=true
```

或者，如果您希望将 stderr 保留在不同的流上:

```supervisor
[program:x]
command=echo test
stdout_logfile=/dev/fd/1
stdout_logfile_maxbytes=0
stderr_logfile=/dev/fd/2
stderr_logfile_maxbytes=0
```

关于docker - supervisord 禁用日志文件或使用 logfile=/dev/stdout，我们在Stack Overflow上找到一个类似的问题： [https://stackoverflow.com/questions/45645758/](https://stackoverflow.com/questions/45645758/)


# docker中执行sed报Device or resource busy错误的处理原因及方式 转载
kuSorZ
博主文章分类：Linux
文章标签: docker | sed
文章分类: Docker
原文出处： https://www.cnblogs.com/xuxinkun/p/7116737.html错误现象

在docker容器中想要修改/etc/resolv.conf中的namesever，使用sed命令进行执行时遇到错误：

/ # sed -i 's/192.168.1.1/192.168.1.254/g' /etc/resolv.conf
sed: can't move '/etc/resolv.conf73UqmG' to '/etc/resolv.conf': Device or resource busy

1.
2.
但是可以通过vi/vim直接修改这个文件/etc/resolv.conf这个文件的内容。
问题原因

sed命令的实质并不是修改文件，而是产生一个新的文件替换原有的文件。这里我们做了一个实验。

我先创建了一个test.txt的文件，文件内容是123。然后我使用sed命令对文件内容进行了替换。再次查看test.txt。

/ # stat test.txt File: test.txt Size: 4 Blocks: 8 IO Block: 4096 regular fileDevice: fd28h/64808d Inode: 265 Links: 1Access: (0644/-rw-r--r--) Uid: ( 0/ root) Gid: ( 0/ root)Access: 2017-07-04 06:28:35.000000000Modify: 2017-07-04 06:28:17.000000000Change: 2017-07-04 06:29:03.000000000/ # cat test.txt 123/ # sed -i 's/123/321/g' test.txt/ # stat test.txt File: test.txt Size: 4 Blocks: 8 IO Block: 4096 regular fileDevice: fd28h/64808d Inode: 266 Links: 1Access: (0644/-rw-r--r--) Uid: ( 0/ root) Gid: ( 0/ root)Access: 2017-07-04 06:29:31.000000000Modify: 2017-07-04 06:29:31.000000000Change: 2017-07-04 06:29:31.000000000/ # cat test.txt321

1.
可以看到文件内容被正确修改了，但是同时，文件的inode也修改了。说明了实质上是新生成的文件替换了原有的文件。但是vim/vi是在原文件基础上修改的，所以inode没有变化。

在docker中，/etc/resolv.conf是通过挂载入容器的。所以当你想去删除这个挂载文件，也就是挂载点时，自然就会报Device or resource busy。

这个跟是不是特权privilege没有关系。即使是privilege的容器，也会有这个问题。
/ # rm /etc/resolv.conf
rm: can't remove '/etc/resolv.conf': Device or resource busy

1.
2.
其实不仅仅/etc/resolv.conf，还有/etc/hostname，/etc/hosts等文件都是通过挂载方式挂载到容器中来的。所以想要用sed对他们进行修改，都会遇到这样的问题。我们可以通过df -h查看容器内的挂载情况。

/ # df -h
Filesystem Size Used Available Use% Mounted on/dev/mapper/docker-253:2-807144231-37acfcd86387ddcbc52ef8dac69d919283fc5d9d8ab5f55fd23d1c782e3b1c70 10.0G 33.8M 10.0G 0% /tmpfs 15.4G 0 15.4G 0% /devtmpfs 15.4G 0 15.4G 0% /sys/fs/cgroup/dev/mapper/centos-home 212.1G 181.8G 30.3G 86% /run/secrets/dev/mapper/centos-home 212.1G 181.8G 30.3G 86% /dev/termination-log/dev/mapper/centos-home 212.1G 181.8G 30.3G 86% /etc/resolv.conf/dev/mapper/centos-home 212.1G 181.8G 30.3G 86% /etc/hostname/dev/mapper/centos-home 212.1G 181.8G 30.3G 86% /etc/hostsshm 64.0M 0 64.0M 0% /dev/shmtmpfs 15.4G 0 15.4G 0% /proc/kcoretmpfs 15.4G 0 15.4G 0% /proc/timer_stats

1.
2.
如何解决

使用vi固然可以，但是对于批量操作就不是很合适了。可以通过sed和echo的组合命令echo "$(sed 's/192.168.1.1/192.168.1.254/g' /etc/resolv.conf)" > /etc/resolv.conf 即可实现替换。

/ # cat /etc/resolv.conf
search default.svc.games.local svc.games.local games.localnameserver 192.168.1.1options ndots:5/ # echo "$(sed 's/192.168.1.1/192.168.1.254/g' /etc/resolv.conf)" > /etc/resolv.conf
/ # cat /etc/resolv.conf
search default.svc.games.local svc.games.local games.localnameserver 192.168.1.254options ndots:5

1.
2.
3.
4.

这里如果使用sed 's/192.168.1.1/192.168.1.254/g' /etc/resolv.conf > /etc/resolv.conf是无效的。最终会导致/etc/resolv.conf内容为空。


## 示例
### Dockerfile
```Dockerfile
CMD mkdir -p /var/log/scancenter \
    && sed 's/INFO\|ERROR/DEBUG/g' -i scancenter/logging.cfg \
    && uwsgi /opt/disk2/var/www/scancenter/3rd/conf/uwsgi-docker/uwsgi.ini --log-master
```

### k8s yaml
```yaml
    spec:
      containers:
      - command:
        - /bin/sh
        - -c
        - mkdir -p /var/log/scancenter &&
          echo -e "10.120.16.12\tapi.s.com\n10.5.25.5\tpp.api.com" >> /etc/hosts &&
          echo "$(sed 's/^-e //g' /etc/hosts)" > /etc/hosts &&
          sed 's/INFO\|ERROR/DEBUG/g' -i scancenter/logging.cfg &&
          uwsgi /opt/disk2/var/www/scancenter/3rd/conf/uwsgi-docker/uwsgi.ini
        env:
        - name: POD_IP_ADDRESS
          valueFrom:
            fieldRef:
              apiVersion: v1
              fieldPath: status.podIP
```
