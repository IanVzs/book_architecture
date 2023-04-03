---
title: CMake 使用Tips
date: 2022-08-30 12:00:56
modified: 
tags: [cmake, cpp, c++]

---

# 在编译时将编译产物放在build
据网友所知，cmake文档中没有记录，仅出于兼容性原因或内部使用而保留：
## -B和-H标志
```bash
cmake -Hpath/to/source -Bpath/to/build
```
## 甚至从源目录 -B
**重要：-B后没有空格**
- 该命令会自动创建build目录
- 之后cd到build下去make即可
```bash
cmake . -Bbuild
```


---

# 样例记录
## OpenCV
- CMakeLists.txt 
- 文件`tree -L 1`
```txt
|-- CMakeLists.txt
|-- DisplayImage.cpp
|-- DisplayImage.out
|-- cmake_install.cmake
|-- CMakeCache.txt
|-- CMakeFiles
|-- Makefile
```
```cmake
cmake_minimum_required(VERSION 2.8)
project( DisplayImageExample )
find_package( OpenCV REQUIRED )
include_directories( ${OpenCV_INCLUDE_DIRS} )
add_executable( DisplayImage.out DisplayImage.cpp )
target_link_libraries( DisplayImage.out ${OpenCV_LIBS} )
```

## Qt

