---
title: Nginx高可用
date: 2021-05-09 09:56:41
categories: [tip, web, learning]
tags: [nginx, keepalived]
---

# Keepalived+Nginx实现高可用
![Keepalived+Nginx实现高可用示意图](https://pic4.zhimg.com/80/v2-ec3208d1ea659d126fe2a008ec5ae927_1440w.jpg "zhuanlan.zhihu.com/p/34943332")

## Nginx 关键字
- IO多路复用epoll(IO复用)
- 轻量,插件: Nginx仅保留了HTTP
- CPU亲和: 每个worker进程固定在一个CPU

## Nginx配置
### 代理
![正向代理示意图](https://pic2.zhimg.com/80/v2-f339964bbc01f2437f93acbac8158715_1440w.jpg "https://zhuanlan.zhihu.com/p/69072041")
![正向代理意义?](https://pic4.zhimg.com/80/v2-21da2af85639573089e42bbf6074cc07_1440w.jpg "https://zhuanlan.zhihu.com/p/69072041")

![反向代理示意图](https://pic4.zhimg.com/80/v2-102d945941e4c24ccc7c4712474cadd7_1440w.jpg "https://zhuanlan.zhihu.com/p/69072041")

### 动静分离
动态页面和静态页面交给不同的服务器来解析

### 负载均衡
```conf
upstream balanceServer {
    server 10.1.22.33:12345;
    server 10.1.22.34:12345;
    server 10.1.22.35:12345;
}

server { 
    server_name  fe.server.com;
    listen 80;
    location /api {
        proxy_pass http://balanceServer;
  }
}
```
#### 机制
- 默认: `轮询`, 单机卡顿, 影响分配在这台服务器下的用户
- 默认: `权重轮询`, 宕机Nginx会自动剔除出队列, `ip_hash`-来源IP分配分配给同个服务器
- `fair`: 根据相应时间均衡分配, 默认不支持. 需安装`upstream_fair`, `url_hash`类`ip_hash`同样需要安装Nginx的`hash软件包`.

## Keepalived 配置
粘贴自: [这里](https://blog.csdn.net/l1028386804/article/details/72801492)

### 概览
VIP|IP|主机名|Nginx端口|默认主从
----:|:----:|:----:|:----:|:----
192.168.50.130|192.168.50.133|liuyazhuang133|88|MASTER
192.168.50.130|192.168.50.134|liuyazhuang134|88|BACKUP

### 主机器配置
```bash
vi /etc/keepalived/keepalived.conf
```

```conf
# 主要
global_defs {
	## keepalived 自带的邮件提醒需要开启 sendmail 服务。 建议用独立的监控或第三方 SMTP
	router_id liuyazhuang133 ## 标识本节点的字条串，通常为 hostname
} 
## keepalived 会定时执行脚本并对脚本执行的结果进行分析，动态调整 vrrp_instance 的优先级。如果脚本执行结果为 0，并且 weight 配置的值大于 0，则优先级相应的增加。如果脚本执行结果非 0，并且 weight配置的值小于 0，则优先级相应的减少。其他情况，维持原本配置的优先级，即配置文件中 priority 对应的值。
vrrp_script chk_nginx {
	script "/etc/keepalived/nginx_check.sh" ## 检测 nginx 状态的脚本路径
	interval 2 ## 检测时间间隔
	weight -20 ## 如果条件成立，权重-20
}
## 定义虚拟路由， VI_1 为虚拟路由的标示符，自己定义名称
vrrp_instance VI_1 {
	state MASTER ## 主节点为 MASTER， 对应的备份节点为 BACKUP
	interface eth0 ## 绑定虚拟 IP 的网络接口，与本机 IP 地址所在的网络接口相同， 我的是 eth0
	virtual_router_id 33 ## 虚拟路由的 ID 号， 两个节点设置必须一样， 可选 IP 最后一段使用, 相同的 VRID 为一个组，他将决定多播的 MAC 地址
	mcast_src_ip 192.168.50.133 ## 本机 IP 地址
	priority 100 ## 节点优先级， 值范围 0-254， MASTER 要比 BACKUP 高
	nopreempt ## 优先级高的设置 nopreempt 解决异常恢复后再次抢占的问题
	advert_int 1 ## 组播信息发送间隔，两个节点设置必须一样， 默认 1s
	## 设置验证信息，两个节点必须一致
	authentication {
		auth_type PASS
		auth_pass 1111 ## 真实生产，按需求对应该过来
	}
	## 将 track_script 块加入 instance 配置块
	track_script {
		chk_nginx ## 执行 Nginx 监控的服务
	} #
	# 虚拟 IP 池, 两个节点设置必须一样
	virtual_ipaddress {
		192.168.50.130 ## 虚拟 ip，可以定义多个
	}
}
```

### 备份机配置
```bash
vi /etc/keepalived/keepalived.conf
```

```conf
# 备份
! Configuration File for keepalived
global_defs {
	router_id liuyazhuang134
}
vrrp_script chk_nginx {
	script "/etc/keepalived/nginx_check.sh"
	interval 2
	weight -20
}
vrrp_instance VI_1 {
	state BACKUP
	interface eth1
	virtual_router_id 33
	mcast_src_ip 192.168.50.134
	priority 90
	advert_int 1
	authentication {
		auth_type PASS
		auth_pass 1111
	}
	track_script {
		chk_nginx
	}
	virtual_ipaddress {
		192.168.50.130
	}
}
```

---

## Nginx 运维命令
```bash
# 快速关闭Nginx，可能不保存相关信息，并迅速终止web服务
nginx -s stop

# 平稳关闭Nginx，保存相关信息，有安排的结束web服务
nginx -s quit

# 因改变了Nginx相关配置，需要重新加载配置而重载
nginx -s reload

# 重新打开日志文件
nginx -s reopen

# 为 Nginx 指定一个配置文件，来代替缺省的
nginx -c filename

# 不运行，而仅仅测试配置文件。nginx 将检查配置文件的语法的正确性，并尝试打开配置文件中所引用到的文件
nginx -t

#  显示 nginx 的版本
nginx -v

# 显示 nginx 的版本，编译器版本和配置参数
nginx -V

# 格式换显示 nginx 配置参数
2>&1 nginx -V | xargs -n1
2>&1 nginx -V | xargs -n1 | grep lua
```
