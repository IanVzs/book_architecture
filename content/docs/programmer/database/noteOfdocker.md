---
title: notes Of docker
created: 2019-02-12 21:37:00
date: 2021-12-16 16:00:00
categories: [note, docker, learning]
tags: [docker, learning]
---

# Docker
![docker img](https://mma.prnewswire.com/media/776689/New_Docker_logo_Logo.jpg?p=facebook "docker")
## 教程手册
[好用的使用教程](https://yeasy.gitbook.io/docker_practice/introduction/why)
### Install
略过~ 😁

## 常见问题和模板
## 用户sudo问题
[debian增加docker用户组,优化每次sudo问题](https://ianvzs.github.io/2016/10/08/makeThingsEasyAndEnjoy/)
或
```
sudo groupadd docker # 安装完docker.io之后一般都会自动创建所以这一步其实没啥用
sudo gpasswd -a $USERNAME docker
newgrp docker # 更新
```
### Docker Mysql编码
```docker-compose
version: "2.2"
services:
  redis:
    image: "redis"
    # ports:
    #  - 6379:6379
    command: redis-server --appendonly yes #一个容器启动时要运行的命令
    restart: always # 自动重启
  myserver:
    image: mainName/myserver
    restart: always # 自动重启
  mainServer:
    image: mainName/mainServer
    #    container_name: mainServerv1.0.0
    depends_on:
      - redis
    ports:
      - 9001:9001
    restart: always
    volumes:
      - "./logs:/src/build/logs"
    links:
      - redis
      - myserver
```
**mysql 编码问题|单条**: `docker run --name predix_mysql -e MYSQL_ROOT_PASSWORD=predix123predix -p 33061:3306  -e LANG=C.UTF-8 -d mysql:5.7 --character-set-server=utf8mb4 --collation-server=utf8mb4_general_ci`

### 时间修改
```Dockerfile
FROM alpine:3.14
RUN apk add -U tzdata && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime &&  echo "Asia/Shanghai" > /etc/timezone

ENV TZ=Asia/Shanghai \
    GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64 \
    PROGRAM_ENV=pro

WORKDIR /src/build

# 复制构建应用程序所需的代码
COPY ./build .

EXPOSE 8088

CMD ["./main"]
```


### bash进入某App内
```bash
docker exec -it webserver bash
```
`webserver` 为APP名称

### Swarm
Docker Compose 
Docker Machine: Mac、Windows区别预先安装。 Linux直接安装  Win10 Hyper-V
发布镜像
镜像充当已部署容器，填写必要信息：username、repo、tag
dockers-compose.yml 副本

其实以上在官方教程有很好说明[在这里](https://docs.docker-cn.com/get-started/part4/#%E5%85%88%E5%86%B3%E6%9D%A1%E4%BB%B6)，但毕竟高级应用，暂且记下。

#### 创建虚拟机来试验一下
```shell
$ docker-machine create --driver virtualbox myvm1
$ docker-machine create --driver virtualbox myvm2
```
第一个管理节点：`docker swarm init`，第二个工作节点`docker swarm join``

##### should like this show:
```
$ docker-machine ssh myvm1 "docker swarm init"
Swarm initialized: current node <node ID> is now a manager.

To add a worker to this swarm, run the following command:

  docker swarm join \
  --token <token> \
  <ip>:<port>
```
通过运行 docker-machine ls 来复制 myvm1 的 IP 地址，然后使用 该 IP 地址并通过 --advertise-addr 指定端口 2377（用于 swarm join 的端口）， 以便再次运行 docker swarm init 命令。例如：
```
    docker-machine ssh myvm1 "docker swarm init --advertise-addr 192.168.99.100:2377"
```
##### 复制此命令，然后通过 docker-machine ssh 将其发送给 myvm2，从而让 myvm2 加入
```
$ docker-machine ssh myvm2 "docker swarm join \
--token <token> \
<ip>:<port>"

This node joined a swarm as a worker.
```

## 至此， 创建swarm完成。

## 连接
使用`ssh`连接`docker-machine ssh myvm1`,运行`docker node ls`查看此中节点。

#### Mybe like this.
```
docker@myvm1:~$ docker node ls
ID                            HOSTNAME            STATUS              AVAILABILITY        MANAGER STATUS
brtu9urxwfd5j0zrmkubhpkbd     myvm2               Ready               Active              
rihwohkh3ph38fhillhhb84sk *   myvm1               Ready               Active              Leader
```
mybe not you are ture. 😂

之后，其余东西z有用到再去官网查看吧。 记录与否，取决于俺。
