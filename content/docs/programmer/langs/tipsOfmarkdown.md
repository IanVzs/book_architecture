---
title: tips Of markdown
date: 2018-05-15 10:00:47
categories: [tip, markdown, learning]
tags: [markdown, learning]
---
# Markdown Notes 📪
![markdown](https://justyy.com/wp-content/uploads/2016/01/markdown-syntax-language.png)

## HTML锚点 - 页面内点击跳转
>可以使用 HTML 锚点来实现点击内容跳转当前页面某标题。
具体实现方法如下：
```markdown
首先，在需要跳转到的标题前插入一个 HTML 锚点，例如：
### <a name="section1">Section 1</a>
这个锚点的名称为 "section1"，可以根据需要自定义。

在需要点击跳转的内容处，使用 Markdown 的链接语法，将链接地址设置为锚点名称加上 # 符号，例如：
[跳转到 Section 1](#section1)
这样，点击这个链接就会跳转到页面中的 "Section 1" 标题处。
```

### 注意事项：
锚点名称必须是唯一的，否则链接可能会跳转到错误的位置。
如果需要跳转到其他页面的锚点，链接地址应该包括页面路径和锚点名称，例如：/path/to/page.html#section1。

--- 

`## Test 二级标题`

## Now I will test the Markdown's hobiy 二级
### Maybe is a nice way to impove my blog. 三级
    原来标题 要# 与正文隔开一个空格…
    ···print “hello Markdown”···
欸？ 怎么回事？上面的文字
莫非是用Tab能将其放到一个容器里？
### 新的区块 ###
    你好，这是我新创建的容器。
    ———好吧，只有直接在标题之下的Tab才能创建
    
    no~，在空行下面也是可以的。

<address@example.com>


## Markdown 字体颜色、流程图
#### 斜体
    *文字*：前后星号斜体

*就像这样？*
### 流程图
st=>start: Start
e=>end: End
opl=>operation: My Operation
sub1=>subroutine: My subroutine
cond=>condition: Yes or No?
io=>inputoutput: catch something

---

呃 流程图我不清楚，不过
### 字体颜色
可以内嵌html
：<font color=red>你好，我是红色吗?</font>，

<font color=#75362109>你好，我是自定义色吗?</font>
即

    <font color=red>你好，我是红色吗?</font>
    <font color=#75362109>你好，我是自定义色吗?</font>

<font color=#ff36ff>刚开始我还在好奇怎么三色RGB怎么变成四个了，原来起作用的还是三个，只不过markdown选择性忽略了多余的字节。😰</font>   这段话的配置如下：

    <font color=#ff36ff>骚气的颜色~</font> 

### 超链接
[Super Link is me?](https://www.google.com.hk)  Yes , you are successful link to Google.hk
    
    [Super Link is me?](https://www.google.com.hk)  

### 表格
|           |           |       |
|:----          |:----:     |    ----:|
|1          |`111`      |a      |
|2          |`222`      |b      |
|3          |`333`      |c      |
|4          |`444`          |d      |
|6          |`555`      |e      |
|7          |`666`      |f      |
#### 序列
* 这是第一行
* 这是第二行
* 第三
* Like This


1. 另种表现
2. 实现方式
3. 阿门
### \@的用法
\@后跟随的关键字可以生成`Github`的搜索超链接 例如： @markdown

### 注释
    [^_^]:
        这里是注释：这个是在制作ppt的时候来写注释的……  
        毕竟在笔记里面写注释怕是失了智…  毕竟不会被显示出来…
[^_^]:
    你看得见我吗？

不过因为上面也说了是支持html语法的。所以……
```html
    <!-- 这里是注释 隐藏区域-->
```
<!-- 这里是注释 隐藏区域2019-0307: 17:05:00-->

### 插入图片：只能插入网图…
![](http://www.fzlol.com/upimg/allimg/141021/1_0T243L11.jpg)

### 关于\`\`\` 痛苦的进行中
```md
    (⊙﹏⊙)， ```这东西是用来标注代码开始的，然而在有的编辑器中，若不是以单独一行会识别为`，也就是对平常语句中的字符的修饰。但是hexo显然不这么认为，所以只好将之前使用```的地方都改成`了 【2018年5月18日 纪念我勤奋的修改史】
```