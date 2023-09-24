---
title: uwsgi 处理记录
date: 2023-08-01 10:30:41
categories: [tip, problem, uwsgi]
tags: [uwsgi]
---

# 日志输出到终端

uwsgi.ini文件中配置
```
log-master = true
; logto=/var/log/uwsgi.log 同时这行不能有
```
启动命令: `uwsgi /opt/disk2/var/www/scancenter/3rd/conf/uwsgi-docker/uwsgi.ini --log-master`

## 隔一段时间卡死,重启不能
当作为纯后端API使用时, 使用 `http-socket` 不使用 `http` 

## 使用supervisor管理uwsgi
#daemonize=/var/log/uwsgi8011.log   #  守护进程一定要注释掉(关键)
