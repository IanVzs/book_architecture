---
title: tip Of vim
date: 2018-05-15 09:56:41
categories: [tip, vim, learning]
tags: [vim, more, less, learning]
---

# Vim 使用
![vim](https://www.vim.org/images/vim_header.gif)
除去“简便生活”里的几条配置，在纠结是否添加到别的地方，果然还是单独给vim一个使用手册比较好……

## 注释
```vim
    # 注释
    1， 12s/^/#/g   
    ---
    # 取消注释
    1， 12s/^#//g     
```
其实 是`vim`中的 `:s`替换命令… 下方解释

或者，使用列编辑的模式:

    v、选择区域、ctrl q置行首、I插入#、Esc应用到全列
    ctrl v、I、#、Esc
    因为有的ctrl q或者ctrl v 不能用……
    
    取消，即使用上述方法选中行首，删除第一个字节即可了

## 替换
```vim
    :s/oldWords/newWords/g
```
g : 代表当前光标所在行。
#### 由此可知:
 `^`表行首标识符。 `/^/`表示行首的空字符。   而取消注释中的`/^#/`即表示行首的`#`，被`//`空字符所替换。


---

## 查找高亮
```vim
    set hlsearch
    set nohlsearch  
```
## 分屏
#### 实现
- 在外部使用`-o` or `-O`参数
- 内部`split` or `vsplit` 
#### 操作
- 移动光标 `Ctrl + w` hjkl
- 移动分区`Ctrl + w` HJKL
- 统一高度`Ctrl + w`  =
- 改变高度`Ctrl + w`  +-


# more and less
阅读器~~~  因为经常读大文件发现了这两个的无敌好处——<font color=#12eeee>快</font>。
### 使用命令
```bash
cat
cat -b 
# 查看且标注行号
-n # 同上，但也会显示空行行号

more
# - space     向下翻页
# - Ctrl+F    同上
# - b         back 返回一页显示
# - Ctrl+B    同上
# - Enter     向下n行,默认1
# - =         输出当前行号
# - v         调用vi/vim
# - !命令     调用shell 执行命令
# - q         退出

less
```

### Vi && Vim

三个模式:
- 命令模式
- 插入模式
- Ex模式

para|:|说明
:---:|:---:|:---
o|:|在当前行下面插入新空白行
dd|:|删除当前一行。
u|:|撤销一步操作
yy|:|当前行->缓冲区
p|:|缓冲区->光标之后插入
n+|y|当前及接下来n行->缓冲区
r|:|替换当前字符
/|:|查找关键字——支持汉字呐！难得
n|:|上命令下切换 next



#### Ex下:
- `set number`: 显示行号。（不过我已经改了配置文件，默认显示）
- ！+命令 代理执行系统命令。如ls cd 
- sh 挂下编辑 显示系统命令行。 ctrl+d返回（PS:命令行下，这是关闭虚拟终端快捷键）
- tip:tail head 等查看命令可以和 >> 命令合用，将文件的首行或者结尾字添加到另一个文档～
