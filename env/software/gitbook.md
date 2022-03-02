# Gitbook
Author: Ian

## 安装
- [官方文档 Github](https://github.com/GitbookIO/gitbook/blob/master/docs/setup.md#setup-and-installation-of-gitbook)
- [Gitbook 打造的 Gitbook 说明文档](https://www.mapull.com/gitbook/comscore/)
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

* 固然可以通过安装相匹配版本进行适配，不过...Ian怕导致本机上的hexo再出现版本不兼容的问题。

## 使用
功能|示例|个人使用习惯(Ian)
--:|:--:|:---
新建book|`gitbook init`|`gitbook init gitbooks/Architecture`
编译和运行服务|`gitbook serve`|
编译|`gitbook serve`|

## pdf
参考自 [码谱](https://www.mapull.com/gitbook/comscore/extend/pdf.html)
- 安装`calibre` `sudo apt install calibre`
- `gitbook pdf <gitbook-folder-location> <pdf-location>.pdf`

新版的gitbook，官方已经不支持导出pdf等电子书格式，官方的解读如下：
```
	PDF and other ebook formats exports ？ The new version of GitBook no longer supports exporting to PDF and other ebooks format. A lot of rich-content does not translate well from the Web to PDF. GitBook will expose a developer API for people to consume and extend their content. It is not excluded that someone build a PDF export tool using the API, but it will not be officially supported. See the section about offline access if this is the part you cared about.
```

## 放到Blog中
*hexo 为例*

- 将gitbook作为自项目添加到当前项目中
```bash
git submodule add git@github.com:IanVzs/book_architecture.git gitbooks/book_architecture
```
- build gitbook和hexo 再将两者静态文件放在一起
```bash
 cd gitbooks/book_architecture/ && gitbook build
 hexo build
 cp -r gitbooks/book_architecture/_book/ public/book_architecture
```
- 使用`https://ianvzs.github.io | localhost:4000`访问原Blog，增加uri`/book_architecture`访问gitbook
