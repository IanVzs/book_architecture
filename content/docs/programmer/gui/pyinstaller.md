---
title: python打包
date: 2022-03-18 18:15:14
category: [note, pyinstaller, 打包]
tags:
---

## 打包
[pyinstaller]()
```
pip install pyinstaller
pyinstaller /path/to/yourscript.py
pyinstaller -key yourpasswd -F /path/to/yourscript.py
```

## 解包
### 解包工具
pyinstxtractor.py
### hex编辑器
010Editor
[下载地址](https://www.sweetscape.com/010editor/)
### 步骤
将pyinstxtractor.py与exe放置在一个文件夹内，打开cmd，输入下列指令生成一个文件夹
```
python pyinstxtractor.py xxx.exe
```
使用010Editor打开文件夹中的main和struct，将struct中E3前面的字节复制粘贴到010Editor的E3前
修改main文件后缀为main.pyc
使用在线工具https://tool.lu/pyc/ 将main.pyc反编译为py文件

### 应对增加key之后的解包
暂无

## 安装程序
- 先将程序打包exe(以多文件模式, 但文件运行起来每次都需要解压再运行很慢，大文件的话多次运行还会挤压C盘空间)
- 将打包好的目录压缩打包zip
- 编写本质为`mv lnk`的脚本
- 把脚本打包成exe
- 执行脚本exe
具体代码可以看[这里](https://github.com/IanVzs/demo_test/tree/master/python_clang/ziputils)
