# Gitbook
Author: ian

## 安装
- [官方文档 Github](https://github.com/GitbookIO/gitbook/blob/master/docs/setup.md#setup-and-installation-of-gitbook)
- 使用`npm`进行安装, 安装npm (v4.0.0 and above is recommended)
- `npm install gitbook-cli -g` 需要`sudo`权限
- 实际在执行`gitbook -V`后才算是安装完成

## 问题
### TypeError: cb.apply is not a function
npm 安装软件不出点儿问题貌似都不是很合适, 该问题代码级问题是因为在适配某些可能本机上并没有安装的npm版本时写了bug，导致执行出错.

所以注释掉相关代码即可，或者直接删除。删除的好处是不会因为编辑器的原因触发npm的某些缩进问题。
```
62. // fs.stat = statFix(fs.stat)
63. // fs.fstat = statFix(fs.fstat)
64. // fs.lstat = statFix(fs.lstat)
```

* 固然可以通过安装相匹配版本进行适配，不过...ian怕导致本机上的hexo再出现版本不兼容的问题。

## 使用
功能|示例|个人使用习惯(ian)
--:|:--:|:---
新建book|`gitbook init`|`gitbook init gitbooks/Architecture`
编译和运行服务|`gitbook serve`|
编译|`gitbook serve`|