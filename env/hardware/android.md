# 将安卓手机用于开发
## Termux
类似于WIN端的Subsystem——其实更像Ubuntu下的虚拟终端。 不过这东西功能强大，除了将安卓里的Linux发挥出来。还有Termux API来调用手机的底层接口。
### ssh与手机连接
#### 手机端`ssh`pc端

1. 电脑生成密匙,无视密码设置全部回车
```
ssh-keygen -t rsa
```
2. 电脑开启sshd服务,用于手机的ssh连接到电脑, 拷贝id_rsa.pub内容
```
systemctl start sshd
```
3. wsl: sshd re-exec requires execution with an absolute path
4. 转去手机端操作
5. 手机连接拷贝
```
$HOME/.ssh/authorized_keys -> 不管用什么复制，然后放到这个路径就好。
```
6. 查看手机的用户名
```
whoami
```
7. 开启服务
```
sshd -p 9000
```
#### pc`ssh`手机端
```
ssh u0_222@192.168.1.14 -p 9000
```
* 可能有文件权限问题
```
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```
😓

### 快捷键(有用的音量键？)

#### 显示扩展功能按键

- 方法一:
    从左向右滑动,显示隐藏式导航栏,长按左下角的KEYBOARD.

- 方法二:
    使用Termux快捷键:音量++Q键

#### 常用快捷键

-  Ctrl键是终端用户常用的按键 – 但大多数触摸键盘都没有这个按键。为此，Termux使用音量减小按钮来模拟Ctrl键。在触摸键盘上按音量减小+ L发送与在硬件键盘上按Ctrl + L相同的输入。
- Ctrl+A -> 将光标移动到行首
- Ctrl+C -> 中止当前进程
- Ctrl+D -> 注销终端会话
- Ctrl+E -> 将光标移动到行尾
- Ctrl+K -> 从光标删除到行尾
- Ctrl+L -> 清除终端
- Ctrl+Z -> 挂起（发送SIGTSTP到）当前进程
- 
- 加键也可以作为产生特定输入的特殊键.
- 
- 音量加+E -> Esc键
- 音量加+T -> Tab键
- 音量加+1 -> F1（和音量增加+ 2→F2等）
- 音量加+0 -> F10
- 音量加+B -> Alt + B，使用readline时返回一个单词
- 音量加+F -> Alt + F，使用readline时转发一个单词
- 音量加+X -> Alt+X
- 音量加+W -> 向上箭头键
- 音量加+A -> 向左箭头键
- 音量加+S -> 向下箭头键
- 音量加+D -> 向右箭头键
- 音量加+L -> | （管道字符）
- 音量加+H -> 〜（波浪号字符）
- 音量加+U -> _ (下划线字符)
- 音量加+P -> 上一页
- 音量加+N -> 下一页
- 音量加+. -> Ctrl + \（SIGQUIT）
- 音量加+V -> 显示音量控制
- 音量加+Q -> 显示额外的按键视图
