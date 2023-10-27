---
title: k8s 配套说明
date: 2023-09-07 20:58:56
category:
  - note
  - k8s
  - docker
tags:
  - Linux
slug:
---

# ctr
如果定义了 -n 应该是namesplace 那么每个命令都得跟上
## load镜像
sudo ctr -n=[k8s.io](http://k8s.io/) images import ${imageTarFile}
## 保存文件
sudo ctr -n k8s.io images export --platform=linux/amd64 hi.tar  101.32.1.4:30002/web-docker/worker:2121
## 切换tag
sudo ctr -n [k8s.io](http://k8s.io/) images tag --force repos.x.com/web-docker/worker:2121 101.32.1.4:30002/web-docker/worker:2121
## 推送镜像
sudo ctr -n [k8s.io](http://k8s.io/) images push -k -u admin:fat213asfdFS2W --plain-http 101.32.1.4:30002/web-docker/worker:2121
## 拉取
sudo ctr -n k8s.io images pull -k -u admin:fat1239ASD124W --plain-http 101.32.1.4:30002/web-docker/worker:2121

# Docker
[[noteOfdocker]]
好像并没有整理docker命令... 后续补吧

## 加载镜像
docker load -i .\hi.tar

## 保存为本地文件
docker save  repos.x.com/web-docker/worker:2121 -o hi.tar
