---
title: 网络(Computer Network)
date: 2021-04-22 15:15:14
category: [note, 网络(Net)]
tags:
---

![计算机网络](https://pic2.zhimg.com/v2-16d997d221222a706345ed08dd13f687_1440w.jpg?source=172ae18b "net")

## C++ & Epoll 
代码可见[这里](https://github.com/IanVzs/demo_test/tree/master/c_lang/epoll_test)

也没啥高级就是:
1. create_socket
2. epoll_create1
3. epoll_ctl(1. & 2.)
4. struct epoll_event events[MAX_EPOLL_EVENTS] = {0};
5. while1: epoll_wait(2, & 4.)
    - eventfd == sockfd accept
    - else => connfd read

所以就是:
1. epoll_event -> 内核空间
2. epitem -> 红黑
3. 设备事件就绪 - callback (epitem -> rdlist链表)
4. emmmm...有需要再继续整理吧

和`select`-`poll`区别为: 一个遍历, 一个触发式的.