# 将安卓手机用于开发
## Termux
类似于WIN端的Subsystem——其实更像Ubuntu下的虚拟终端。 不过这东西功能强大，除了将安卓里的Linux发挥出来。还有Termux API来调用手机的底层接口。
### XFCE4
**步骤**：
1. 安装`Termux`
2. 执行`pkg update`
3. 执行`pkg install git && git clone https://github.com/Yisus7u7/termux-desktop-xfce.git`
4. 执行`cd termux-desktop-xfce && bash boostrap.sh`

当然，3&4步可以合并为一句`curl -sLf https://raw.githubusercontent.com/Yisus7u7/termux-desktop-xfce/main/boostrap.sh | bash`
### VNC
默认VNC只能通过`localhost:1`来连接，局域网不能访问。想用大屏来看就不是很方便。
```
# 先执行`vncserver`使用本机的`VNC Viewer`看看效果，主要是需要先设置一下密码
vncserver
# 现在还无法通过局域网连接
# 去设置
cd ~/.vnc/
vim config # 打开最后一行注释
# 重新运行
vncserver -kill :1
vncserver
```
#### 配置文件一览

将`config`文件最后一行的注释打开，即可

```
## Supported server options to pass to vncserver upon invocation can be listed
## in this file. See the following manpages for more: vncserver(1) Xvnc(1).
## Several common ones are shown below. Uncomment and modify to your liking.
##
# securitytypes=vncauth,tlsvnc
# desktop=sandbox
geometry=1280x720
# localhost
# alwaysshared 将这行注释取消注释
alwaysshared # 修改成这样
```
### 现在各个版本概览
- python - 3.10
- clang - 14.0.5
- opencv - 4.5.5
### NumPy
```bash
# pip3 install numpy 不能安装
MATHLIB="m" pip3 install numpy
# numpy      1.22.4
```
### C++ & OpenCV
现在安装`opencv-python`还有问题,可能问题出现在安装`numpy`上,但后来经过努力安装好了,但版本或者其他问题导致还是不能正常运行.但C++还是很好呀.
```bash
pkg install opencv
```

#### opcv.cpp
```cpp
#include <opencv2/opencv.hpp>
#include <iostream>

using namespace cv;
using namespace std;

int main()
{
		Mat src = imread("logo-red.png", IMREAD_GRAYSCALE);
		if (src.empty()) {
				printf("could not find the image\n");
				return -1;
		}

		imwrite("grayscale.png", src);
		printf("save grayscale success\n");
		// waitKey(0);
		// system("path");
		// getchar();
		return 0;
}
```

#### 编译 & 运行
```bash
g++ opcv.cpp -o opcv `pkg-config --cflags --libs opencv4`
./opcv
```
##### 指定编译器版本
opencv4 需要C++11
```
g++ opcv.cpp -o opcv `pkg-config --cflags --libs opencv4` -std=c++11
```

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
