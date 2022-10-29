---
title: Dgraph
date: 2021-12-8 18:30:23
categories: [Dgraph, 图数据库]
tags:
---

![Dgraph](https://dgraph.io/docs//images/dgraph.svg "Dgraph")
## 问题
在`新手村`的时候使用`dgraph/standalone` 但此时(2021-12-8 18:30:23)[文档](https://dgraph.io/docs/get-started/)使用的版本为`dgraph/standalone:v21.03.2`但是这个版本的[Ratel UI](http://localhost:8000)不工作.... 导致hello 不了 world很是难受

结果换了`dgraph/standalone:v20.11.3`好了诶.
```
sudo docker run --rm -it -p "8080:8080" -p "9080:9080" -p "8000:8000" -v ~/dgraph:/dgraph "dgraph/standalone:v20.11.3"
http://127.0.0.1:8000
```
