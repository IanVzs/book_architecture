---
title: OpenCV
date: 2021-04-22 17:23:23
categories: [tip, 换源]
tags:
---

![opencv](https://opencv.org/wp-content/uploads/2020/07/cropped-OpenCV_logo_white_600x.png "cv")
## 问题(libSM.so.6 缺失)
### 运行opencv的代码时，报以下错误：
```
Traceback (most recent call last):
  File "data_generator.py", line 24, in <module>
    import cv2
  File "/usr/local/lib/python3.5/dist-packages/cv2/__init__.py", line 3, in <module>
    from .cv2 import *
ImportError: libSM.so.6: cannot open shared object file: No such file or directory
```

### 解决
原因是缺少共享文件库，解决办法如下：

1. 安装apt-file
$ apt-get update
$ apt-get install apt-file
$ apt-file update

2. 寻找依赖库
$ apt-file search libSM.so.6
> libsm6: /usr/lib/x86_64-linux-gnu/libSM.so.6
> libsm6: /usr/lib/x86_64-linux-gnu/libSM.so.6.0.1

根据提示，安装合适的依赖库
$ apt-get install libsm6

3. 其余文件缺失类似, 即可解决问题。