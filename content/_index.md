---
title: Introduction
type: docs
---

# About Me
## 简介

{{< columns >}}
## 程序员笔记

程序员笔记包含了硬件、软件两大类,分别包括
- **硬件**：树莓派、安卓、以及其他开发板、鼠标键盘屏幕等外设的配置使用信息和其他信息
- **软件**：编程语言、数据库、GUI、网络、机器学习(_AI_)、游戏&仿真

目前编程语言涵盖`Python`、`Golang`、`C/C++`语言，以后或许会增加，也或许不会。看使用情况。基本遵循`需要什么用什么学什么`的原则。

<--->

## 个人博客(_Blog_)

与程序员笔记(开源在[Github](https://github.com/IanVzs/book_architecture)，理论上接受所有人的提交)不同,Blog部分只是个人所写的一些细碎文章，不成体系，写的也很随意。当然不会排除写多了会进行整理,提交到程序员笔记或者另开新仓库的可能(而且极有可能)。

另外**Example Site**和**Shortcodes**是构建本站工具[hugo](https://github.com/gohugoio/hugo)所附带的教学文章。因为目前使用还不是很熟悉，所以姑且暂时放在本站中方便检索查阅，以后使用熟练之后再进行清理。
{{< /columns >}}


## 如何获取内容和维护

您应该已经掌握 **git**, **markdown**
_book_architecture_ 目录 `archetypes  config.toml  config.toml.template  content  data  layouts  public  resources  static  themes`，内容都存储在`content`中，`docs`-文章，`menu`-目录，`_index.md`-本页内容

    git clone https://github.com/IanVzs/book_architecture.git
    # 编辑book_architecture/content中的内容
    # 审阅提交

## 如果想要建立自己的静态网页托管

- tips: 使用`hugo serve --bind 0.0.0.0`可以在局域网访问hugo静态网站。

请参阅[Github Pages](https://pages.github.com/) or [Gitee Pages](https://gitee.com/help/articles/4136)，and [HUGO](https://gohugo.io/getting-started/quick-start/)，请💪
