---
title: Qt/PySide
date: 2022-01-18 14:15:23
categories: [tip, qt, pyside]
tags:
---

![pyside](https://qt-wiki-uploads.s3.amazonaws.com/images/3/33/Py-128.png "pyside")

## 绘制界面和使用
安装`Qt`本体后可以使用`Design`绘制图形化界面.而后保存为`xxx.ui`文件.
### 转换为py
* 注意版本
```bash
pyside6-uic xxx.ui -o ui_xxx.py
```
不过信号槽就不要在`Design`中去标了, 放在`py`中手动创建和管理目前看来更为直观方便.
