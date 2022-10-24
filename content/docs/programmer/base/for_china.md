---
title: 各个软件换源
date: 2021-04-22 17:04:15
modified: 2022-02-10 17:45
categories: [tip, 换源]
tags: 
---

![mu ou](http://img.hc360.com/broadcast/info/images/200909/200909101744424019.jpg "ma liang")

在国内用原源都会很慢, 所以总结一下各个软件(?吧)换源方法.
## apt
可解决版本升级时的问题,即使用了国内源,最后一个文件不知道为什么还是从国外拉取...
```bash
# sudo touch /etc/apt/apt.conf
sudo vim /etc/apt/apt.conf
```
-> Acquire::http::Proxy "http://127.0.0.1:8001";

## FreeBSD
>> mkdir -p /usr/local/etc/pkg/repos
>> vim /usr/local/etc/pkg/repos/bjtu.conf
```
bjtu: {
	url: "pkg+http://mirror.bjtu.edu.cn/reverse/freebsd-pkg/${ABI}/quarterly",
	mirror_type: "srv",
	signature_type: "none",
	fingerprints: "/usr/share/keys/pkg",
	enabled: yes
}
FreeBSD: { enabled: no }
```
>> pkg update

## Qt
### 源
- 中国科学技术大学：http://mirrors.ustc.edu.cn/qtproject/
- 清华大学：https://mirrors.tuna.tsinghua.edu.cn/qt/
- 北京理工大学：http://mirror.bit.edu.cn/qtproject/
- 中国互联网络信息中心：https://mirrors.cnnic.cn/qt/

## Python Pip
```bash
pip install --index https://pypi.mirrors.ustc.edu.cn/simple/ dlib(numpy等包名)
```
### 源
- 阿里云       http://mirrors.aliyun.com/pypi/simple/
- 中国科技大学 https://pypi.mirrors.ustc.edu.cn/simple/
- 豆瓣(douban) http://pypi.douban.com/simple/
- 清华大学     https://pypi.tuna.tsinghua.edu.cn/simple/
- 中国科学技术大学 http://pypi.mirrors.ustc.edu.cn/simple/

## Nodejs Npm
不过好像换了会有问题.Npm各个包依赖混乱不堪,不忍直视.
```bash
npm install --registry=https://registry.npm.taobao.org
```

## Ubuntu
地址: `/etc/apt/sources.list`

注意`备份`, `sudo` 权限
### 文件内容如下, 原源部分没有粘贴完全
#### 20.04 Focal Fossa
```
# 国内源
# Ali
deb http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse

# QH
# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-updates main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-updates main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-backports main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-backports main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-security main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-security main restricted universe multiverse

# See http://help.ubuntu.com/community/UpgradeNotes for how to upgrade to
# newer versions of the distribution.
deb http://archive.ubuntu.com/ubuntu/ focal main restricted
# deb-src http://archive.ubuntu.com/ubuntu/ focal main restricted

## Major bug fix updates produced after the final release of the
## distribution.
deb http://archive.ubuntu.com/ubuntu/ focal-updates main restricted
# deb-src http://archive.ubuntu.com/ubuntu/ focal-updates main restricted


# 原源(以下可保存也可不保存吧, 以上可选其一也可全部都放着, 目前没啥问题)
## N.B. software from this repository is ENTIRELY UNSUPPORTED by the Ubuntu
## team. Also, please note that software in universe WILL NOT receive any
## review or updates from the Ubuntu security team.
```

## Pi
同`debian`

