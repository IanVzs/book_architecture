---
title: 安装问题
date: 2022-01-15 16:24:41
categories: [tip, install]
tags: [install, npm, nodejs]
---
# 记录一些安装问题
## Debian 使用 apt-add-repository(ppa)
```
sudo apt update
sudo apt install software-properties-common
```
## FreeBSD桌面
- 换源
- pkg install xorg xfce
- echo 'dbus_enable="YES"' >> /etc/rc.conf
- echo "/usr/local/etc/xdg/xfce4/xinitrc" > ~/.xinitrc
- startx
### 登录界面
- pkg install slim slim-themes
- echo 'slim_enable="YES"' >> /etc/rc.conf
### vbox(没测试)
- pkg install virtualbox-ose-additions
- 向`/etc/rc.conf`写入
```
vboxguest_enable="YES"
vboxservice_enable="YES"
```
仅供参考看[这里](https://www.cnblogs.com/mocuishle/p/15582173.html) 因为vbox显卡太弱安装了vmware后就一直没用回过vbox,我还没测试过
### vmware
- pkg install open-vm-tools xf86-video-vmware xf86-input-vmmouse
- 继续向`/etc/rc.conf`中写入
```
hald_enable="YES"
moused_enable="YES"
# vmware_guest_vmblock_enable="YES"
# vmware_guest_vmhgfs_enable="YES"
# vmware_guest_vmmemctl_enable="YES"
# vmware_guest_vmxnet_enable="YES"
# vmware_guest_enable="YES"
```
下面注释掉的是因为在测试中如果打开的话会有各种问题....尤其鼠标
其他可见[这里参考](https://www.jianshu.com/p/d4e32dbfe1e6)
仅供参考, 这里面的东西很多都是有问题的.
## Clash(樹莓派4 cli版)
- 下載對應版本[地址](https://github.com/Dreamacro/clash/releases/tag/v1.8.0)
- 注意不要選擇1.9.0版本,我用的1.8.0,9多人反映(以及我)有問題
- 我是樹莓派4 用的`armv8` 樹莓派3 據說用`armv7`
- 解壓給運行權限
- 從無論某處拿到配置文件 大多給訂閱地址, 但這裏使用需要我們手動下載好
- 配置`systemd`或其他(手動啓動的話注意需要root,或者給相應用戶配置端口權限)
```systemd
[Unit]
Description=clash daemon
[Service]
Type=simple
User=root
ExecStart=/home/pi/apps/clash-linux-armv8-v1.8.0/clash-linux-armv8-v1.8.0 -f /home/pi/.config/clash/config.yaml
Restart=on-failure
[Install]
WantedBy=multi-user.target
```
- 啓用
```bash
sudo systemctl enable clash
sudo systemctl start clash
sudo systemctl status clash
```

## Windows下wsl2 安装 npm && nodejs
摘抄自[微软说明文档](https://docs.microsoft.com/zh-cn/windows/dev-environment/javascript/nodejs-on-wsl)
1. 安装nvm (Node 版本管理器)
国内网可能有问题, 下载下保存直接`bash install.sh`就可安装.
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
```
2. `command -v nvm`验证是否安装成功,它会自行添加`.bashrc`需重启`bash`
3. `nvm ls`查看Node版本
4. `nvm install --lts`即可安装lts版, `nvm install node`安装最新版
5. 会安装这么多东西
```bash
->     v16.13.2
default -> lts/* (-> v16.13.2)
iojs -> N/A (default)
unstable -> N/A (default)
node -> stable (-> v16.13.2) (default)
stable -> 16.13 (-> v16.13.2) (default)
lts/* -> lts/gallium (-> v16.13.2)
lts/argon -> v4.9.1 (-> N/A)
lts/boron -> v6.17.1 (-> N/A)
lts/carbon -> v8.17.0 (-> N/A)
lts/dubnium -> v10.24.1 (-> N/A)
lts/erbium -> v12.22.9 (-> N/A)
lts/fermium -> v14.18.3 (-> N/A)
lts/gallium -> v16.13.2
```
6. 可以了 或者[官网下载](https://nodejs.org/en/download/)不过在wsl2里node好使唤,npm无效(只有0K)...

## Dgraph
问题见: [这里](https://ianvzs.github.io/2021/12/08/tips/dgraph/)
