# 常用命令
## 创建topic
 
```bash
sh kafka-console-producer.sh --create --topic scanner_device_log --bootstrap-server localhost:9092 --partitions 0 --replication-factor 1
```
## 发送接收测试
```bash
sh kafka-console-producer.sh --broker-list localhost:9092 --topic test
sh kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic test
```


# 单机部署
本文[链接🔗](https://cloud.tencent.com/developer/article/2303681)
[Kafka](https://cloud.tencent.com/developer/tools/blog-entry?target=https%3A%2F%2Fken.io%2Fnote%2Fkafka-cluster-deploy-guide)是一个开源的分布式消息引擎/消息[中间件](https://cloud.tencent.com/product/tdmq?from_column=20065&from=20065)，同时Kafka也是一个流处理平台。Kakfa支持以发布/订阅的方式在应用间传递消息，同时并基于消息功能添加了Kafka Connect、Kafka Streams以支持连接其他系统的数据([Elasticsearch](https://cloud.tencent.com/developer/tools/blog-entry?target=https%3A%2F%2Fken.io%2Fnote%2Felk-deploy-guide)、[Hadoop](https://cloud.tencent.com/developer/tools/blog-entry?target=https%3A%2F%2Fken.io%2Fnote%2Fhadoop-cluster-deploy-guide)等) [Kafka](https://cloud.tencent.com/developer/tools/blog-entry?target=https%3A%2F%2Fken.io%2Fnote%2Fkafka-cluster-deploy-guide)在生产环境下使用通常是集群化部署的，同时也要依赖[ZooKeeper](https://cloud.tencent.com/developer/tools/blog-entry?target=https%3A%2F%2Fken.io%2Fnote%2Fzookeeper-cluster-deploy-guide)集群，这对开发测试环境来说比较重，不过我们可以通过[Docker](https://cloud.tencent.com/product/tke?from_column=20065&from=20065)便捷Kafka单机的方式，节省部署时间以及机器资源

### 1、本文主要内容

- 通过Docker手动部署ZooKeeper&Kafka
- 通过Docker Compose快捷部署ZooKeeper&Kafka
- Kafka发送、接收消息测试

### 2、本文环境信息

|工具|说明|适配|
|---|---|---|
|Docker|Docker CE 23.0.5|Docker CE 
|Docker Desktop|4.19.0|4.0.x|
|ZooKeeper|zookeeper:3.8（Docker Image ）|zookeeper:3.x（Docker Image ）|
|Kafka|wurstmeister/kafka:2.13-2.8.1（Docker Image）|wurstmeister/kafka:2.x（Docker Image）|

## 二、手动部署Kafka

### 1、拉取镜像

先通过docker pull 命令把镜像拉取下来，方便后续操作

```javascript
docker pull zookeeper:3.8
docker pull wurstmeister/kafka:2.13-2.8.1
```

### 2、创建数据卷

创建数据卷，方便数据持久化

```javascript
docker volume create zookeeper_vol
docker volume create kafka_vol
```

### 3、创建ZooKeeper容器

创建zookeeper-test[容器](https://cloud.tencent.com/product/tke?from_column=20065&from=20065)，同时挂载数据卷和并指定端口映射（2181）

```javascript
docker run -d --name zookeeper-test -p 2181:2181 \
--env ZOO_MY_ID=1 \
-v zookeeper_vol:/data \
-v zookeeper_vol:/datalog \
-v zookeeper_vol:/logs \
zookeeper
```

### 4、创建Kafka容器

创建kafka-test容器，同时挂载数据卷和并指定端口映射（9092），并将zookeeper-test链接到该容器，使Kafka可以成功访问到zookeeper-test，Kafka相关参数通过环境变量（—env）设置

```javascript
docker run -d --name kafka-test -p 9092:9092 \
--link zookeeper-test \
--env KAFKA_ZOOKEEPER_CONNECT=zookeeper-test:2181 \
--env KAFKA_ADVERTISED_HOST_NAME=localhost \
--env KAFKA_ADVERTISED_PORT=9092  \
--env KAFKA_LOG_DIRS=/kafka/logs \
-v kafka_vol:/kafka  \
wurstmeister/kafka
```

通过这种方式可以掌握整个部署过程，也可以达成ZooKeeper的复用，不过稍显繁琐

## 三、Docker Compose部署Kafka

### 1、创建Docker Compose配置文件

使用Docker Compose可以将一系列创建及映射资源（网络、数据卷等）操作放在配置文件中，并且可以通过depends_on参数指定容器的启动顺序，通过environment参数指定Kafka需要的基本参数信息 创建kafka-group.yml，保存以下信息

```yaml
version: '3'
name: kafka-group
services:
  zookeeper-test:
    image: zookeeper
    ports:
      - "2181:2181"
    volumes:
      - zookeeper_vol:/data
      - zookeeper_vol:/datalog
      - zookeeper_vol:/logs
    container_name: zookeeper-test

  kafka-test:
    image: wurstmeister/kafka
    ports:
      - "9092:9092"
    environment:
      KAFKA_ADVERTISED_HOST_NAME: "localhost"
      KAFKA_ZOOKEEPER_CONNECT: "zookeeper-test:2181"
      KAFKA_LOG_DIRS: "/kafka/logs"
    volumes:
      - kafka_vol:/kafka
    depends_on:
      - zookeeper-test
    container_name: kafka-test
volumes:
  zookeeper_vol: {}
  kafka_vol: {}
```

### 2、启动容器组

```javascript
# 启动Kafka容器组
docker compose -f kafa-group.yml up -d

# 输出示例
 ✔ Network kafka-group_default         Created 
 ✔ Volume "kafka-group_zookeeper_vol"  Created 
 ✔ Volume "kafka-group_kafka_vol"      Created 
 ✔ Container zookeeper-test            Started 
 ✔ Container kafka-test                Started
```

## 四、Kafka消息测试

### 1、启动Kafka Producer

> 新开一个命令后窗口，然后执行以下命令，启动Kafka Producer，准备往topic:test发送消息

```javascript
# 进入容器
docker exec -it kafka-test /bin/bash

# 进入Kafka bin目录
cd /opt/kafka/bin

# 启动Producer
sh kafka-console-producer.sh --broker-list localhost:9092 --topic test
```

### 2、启动Kafka Consumer

> 新开一个命令后窗口，然后执行以下命令，启动Kafka Consumer，订阅来自topic:test的消息

```javascript
# 进入容器
docker exec -it kafka-test /bin/bash

# 进入Kafka bin目录
cd /opt/kafka/bin

# 启动Consumer
sh kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic test
```

### 3、收发消息测试

>在Producer命令行窗口输入内容，然后回车即可发送消息
>然后再Consumer命令行窗口可以看到收到的消息

![[kafka测试效果图.png]]


## 五、备注

### 1、可能碰到的问题

如果你碰到ZooKeeper、Kafka容器无法正常启动，可以删除数据卷以及容器后进行创建

```javascript
# 停用&删除容器
docker stop zookeeper-test kafka-test
docker rm zookeeper-test kafka-test

# 删除数据卷
docker volume rm zookeeper_vol kafka_vol
docker volume rm kafka-group_kafka_vol kafka-group_zookeeper_vol
```
### 2、相关阅读

- [https://ken.io/note/zookeeper-cluster-deploy-guide](https://cloud.tencent.com/developer/tools/blog-entry?target=https%3A%2F%2Fken.io%2Fnote%2Fzookeeper-cluster-deploy-guide)
- [https://ken.io/note/kafka-cluster-deploy-guide](https://cloud.tencent.com/developer/tools/blog-entry?target=https%3A%2F%2Fken.io%2Fnote%2Fkafka-cluster-deploy-guide)
- [https://hub.docker.com/_/zookeeper](https://cloud.tencent.com/developer/tools/blog-entry?target=https%3A%2F%2Fhub.docker.com%2F_%2Fzookeeper)
- [https://hub.docker.com/r/wurstmeister/kafka](https://cloud.tencent.com/developer/tools/blog-entry?target=https%3A%2F%2Fhub.docker.com%2Fr%2Fwurstmeister%2Fkafka)

## 六、端到端延迟
> 来自: [一文理解kafka端到端的延迟](https://zhuanlan.zhihu.com/p/143146567)
### **理解到端的延迟(end-to-end latency)**

端到端延时是指应用逻辑调用`KafkaProducer.send()`生产消息到该消息被应用逻辑通过`KafkaConsumer.poll()`消费到之间的时间。

#### 因此，端到端的延迟主要会由以下几个部分组成:
- `Produce time`: 内部Kafka producer处理消息并将消息打包的时间
- `Publish time`: producer发送到broker并写入到leader副本log的时间
- `Commit time`: follower副本备份消息的时间
- `Catch-up time`: 消费者追赶消费进度，消费到该消息位移值前所花费的时间
- `Fetch time`: 从broker读取该消息的时间

![[kafka端到端.webp]]

![[端到端延迟图.jpg]]