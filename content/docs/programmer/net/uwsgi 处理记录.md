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

## 查看性能数据
1. 安装 `uwsgitop`
2. 查看 `uwsgi` `stats`写入位置
3. 查看

```bash
pip install uwsgitop
cat /opt/trunk/textcheck/3rd/uwsgi/config.ini | grep stats
# > stats=/var/run/uwsgi/uwsgi.status
uwsgitop /var/run/uwsgi/uwsgi.status
# > uwsgi-2.0.19.1 - Wed Oct 18 18:13:48 2023 - req: 113 - RPS: 0 - lq: 0 - tx: 75.1K
```
>node: app-58d8477f4-26fzb - cwd: /app - uid: 0 - gid: 0 - masterpid: 8
 WID    %       PID     REQ     RPS     EXC     SIG     STATUS  AVG     RSS     VSZ     TX      ReSpwn  HC      RunT    LastSpwn
 1      28.3    132942  32      0       0       0       idle    19161ms 0       0       15.2K   1       0       155394.03       17:34:42
 2      28.3    132950  32      0       0       0       idle    1781ms  0       0       20.1K   1       0       126123.093      17:34:42
 3      22.1    132958  25      0       0       0       idle    5982ms  0       0       16.9K   1       0       127199.778      17:34:42
 4      21.2    132963  24      0       0       0       idle    15274ms 0       0       22.8K   1       0       144018.093      17:34:42
