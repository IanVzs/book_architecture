---
title: Linux
date: 2016-04-08 16:58:56
category: [note, linux, learning]
tags: [Linux, learning]
slug:
---

![linux](https://static1.makeuseofimages.com/wp-content/uploads/2015/01/best-linux-distros.jpg)

## Ubuntu22.04 依赖项整理
- vbox: libqt5opengl5
- kate: konsole
- Qt5.12.12: mesa-common-dev, libgl1-mesa-dev
- OpenCV4.6.0: libgtk2.0-dev, pkg-config, libcanberra-gtk-module
	- 如果没有安装这俩依赖不会影响编译，但是编译后会有功能损失，补充安装后不会修复；
	- 如果想修复，只能安装后再编译一次；
## dpkg .deb
### Install
`sudo dpkg -i file.deb`
### c l r P L s
- `-c`列出内容
- `-l`提取包信息
- `-r`移除一个已安装的包
- `-P`完全清除一个已安装包
- `-L`列出安装所有文件清单
- `-s`显示已安装包信息

## WSL
[wsl问题](https://github.com/IanVzs/ianvzs.github.io/issues/7)
因为后面不太喜欢这种东西了,还是上了物理机. 所以就不粘贴过来了.
## sudo apt upgrade
>E: Sub-process /usr/bin/dpkg returned an error code (1)

### 解决
*sudu下*
1. 备份`/var/lib/dpkg/info`
2. 新建`/var/lib/dpkg/info`
3. 重新执行更新
4. 合并`/var/lib/dpkg/info` 和 备份文件
5. 完

### 说明
非原理性解决方案, 若解决不了, 另寻他法或者需要直击灵魂.


## 磁盘操作
### NTFS
#### 一般发行版
在此中可以使用`ntfsfix`, 不过刚才看了一圈儿, 好像, 这工具就是来源于下面所介绍的
#### 树莓派
因为没有预装`ntfsfix`, 所以

- 安装 `ntfs-3g` 很久远的工具: `sudo apt install ntfs-3g` (看3g就知道年代久远 😄)
- 取消挂载, `sudo umount /dev/sda{N}`
- 重新挂载, `mount –t ntfs /dev/sda{n} /media/pi`

就可以有`读写`权限了. 不然只有读的, 挺不好的.

不过在windows放了缓存在里面的话就没办法挂载为`可写`了， 方法是取消Win的快速启动功能后关机，不使用休眠.

### 磁盘查询命令
```bash
fdisk -l
df -h
```

LVM概要（がいよう）

**自弁の理解**：
- 将零散的集合起来，再进行动态分组。
- PV >> VG >> LV

### **じゃあ作成（さくせい）**：
```bash
pvcreat disk1 disk2 di3 ...　# 集合
pvs|pvdisplay

vgcreat 集合name 1 2 3 ...  # 集合

vgs|vgdisplay

lvcreat -n name -L size 集name 
lvs|lvdisplay
```

### **格式化磁盘:**
```bash
mkfs.ext4 /dev/集name/name  # 格式化此（PS：路径为所示）
```
**注:** 不过要采用这种方法来给Linux扩容的话需要之前时就选定Linux磁盘管理为LVM，否则主目录在之后不能添加lv组，也就谈不上添加。

### LVMの削除（さくじょ）：
```bash
LV  lvremove /dev/... 
VG  vgremove 集name
PV(物理卷) pvremove /dev/...
```

### disk LVの追加（ついか）：
```bash
lvexpend -L +1G /dev/集name/name
# 增加了空白空间

resize2fs /dev/... 更新文件系统 使空白空间得以有身份（文件系统）
```

### disk VGの追加
```bash
pvcreat /dev/sdd(new)

vgexpend 集name /dev/sdd
```

## 网络
### SSH 远程终端控制
`ssh root(usrname)@192.168.^.^   (IP)`
输入密码错误之后——就…之前解决过，然而忘了上次怎么解决的了(京东云)反正这次是等着等着突然就能连接了。 以后可得把解决方案记录到这儿ヽ(*。>Д<)o゜

另外，`ssh`公钥🔑连接方式可以参考`makethingseasy`中的描写。
### ping 测试连通
mtr 测试网络+每个路由信息
`* + IP `

### VNC 桌面远程
Emmmm 当时还写了这个？现在倒是用这个在链接树莓派o(∩∩)o...哈哈(2021-04-22)

## 壓縮打包
- `tar -zxvf **.tar.gz`: `.tar.gz`
- `tar -jxvf **.tar.bz2`: `.tar.bz2`
### tar
```shell
    tar xvzf fileName.tar.gz
    tar cvzf fileName.tar.gz targerName
```
`x`: 解压  `c` : 压缩

## Ubuntu 16.04 升级 Ubuntu 18.04
___ 经尝试真的不如备份自我资料后重装……因为太…慢…了…   更新还不稳。
[^_^]:
    2018年6月5日13点44分

其实还好…   就是更新速度慢了点儿。早不到十点更新到了下午13点38分。不过基于是一键式的所以还是有多点儿好处的。
更新命令
```bash
sudo do-release-upgrade
# 提示是没法找到可用更新…
# 所以  之后增加了
-c
# 还是不行
-d 
# 参数完成更新
```
但是`python`被重装了！！！！ 里面的包都没了…🐎a算了，好在软件级别的东西都还在…另外`pip`也损坏了，`apt`安装也失败，后面我就用了`.py`脚本重新安装，所以`apt`卸载再重装没试，不知道行不行。 收回前面“软件级别的都还在”，其实软件级别的也待测。

## 设定系统常量
在用户目录下`profile`文件中可通过`export` 增加(一般来说是增加路径)
```bash
export IAN=/mnt/c/Users/ian
sourse ~/.profile
```
之后便可通过`cd $IAN` 来访问`win`下的用户目录。当然，这个方法是在添加`GoPath`时注意到的。


[^_^]:
    2018年6月5日10点25分

emm  其实在`/etc/profile` 文件下才是系统王道

### ps
今年面试还碰到个问这个问题，说什么是变量..... 把我给整蒙了.....
结果一番问下才发现他想问的就是放在`/etc/profile`和`~/.profile`里有啥区别，

啥是`系统,用户,会话`级变量.唉.. 有时候突然听到基本问题就觉得对方是不是有什么深意...
[^_^]:
    2021年4月22日11点52分

## tmux 虚拟多终端
类似于vim多窗口编辑一类的东西，emm 或者说图形化`ubuntu`使用`ctrl+alt+t`叫出来的东西。这么一对比的话就是无界面化的虚拟终端——那个是界面里的虚拟终端嘛。 用于解决`ssh`连接远程开启应用，断开后不关闭进程的方案。因为`nohup`好像并不稳定的样子……
不过用起来… 不太了解怎么这就能够持久化了…因为毕竟是虚拟窗口，间`makethingseasy`中，其实…好像…大概…没什么关系吧。这两者。

## 最大文件数/单进程最大文件数
`bump fs.nr_open + fs.max-file to their largest possible values`

```bash
cat /proc/sys/fs/file-max
cat /proc/sys/fs/nr_open
```
今天(2021-04-22)看`epoll`的时候好奇看了一下,发现我的fs/file-max居然有`9223372036854775807`震惊一下.
