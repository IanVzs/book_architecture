# FreeBSD
## 桌面
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
其他可见[这里参考](https://www.jianshu.com/p/d4e32dbfe1e6) => 该Blog仅供参考, 这里面的东西很多都是有问题的.

## 换源
```bash
mkdir -p /usr/local/etc/pkg/repos
vim /usr/local/etc/pkg/repos/bjtu.conf
```
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
### 附录
Ian 整理的[各个软件换源Blog](https://ianvzs.github.io/2021/04/22/tips/for_china/)
