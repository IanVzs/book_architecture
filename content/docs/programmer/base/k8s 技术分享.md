---
title: k8s
date: 2023-09-07 20:58:56
category:
  - note
  - k8s
  - docker
tags:
  - Linux
slug:
--
-
# k8s技术分享

# 工作负载资源

## 一、[pod](https://kubernetes.io/zh-cn/docs/reference/kubernetes-api/workload-resources/pod-v1/)

### 1. 概要
1. 可创建管理、最小的可部署计算单元，是可以在主机上运行的容器的集合
2. 我们的服务都在其中运行。如我们的服务是nginx，则最内层是我们的服务 `nginx`，运行在 `container` 容器当中。`container` (容器) 的本质是进程，而 `pod` 是管理这一组进程的资源
3. 所以pod可视为一个极为轻量化、没插网线的电脑，如果所需任务无需交互，那么用pod就很合适。例如给它挂载一个文件来训练模型、生成报表，可以根据场景使用 [Job](https://kubernetes.io/zh-cn/docs/reference/kubernetes-api/workload-resources/job-v1/) 或者 [CronJob](https://kubernetes.io/zh-cn/docs/reference/kubernetes-api/workload-resources/cron-job-v1/) 或者其它
  

### 图示关系如下

  
![[k8s-pod-insert.png]]
### 2. pod网络


1. 当然，`pod` 可以管理多个 `container`，又因为`container` (容器) 的本质是进程，如果有本地网络通信需求(使用 localhost 或者 Socket 文件进行本地通信)，在这些场景中使用 `pod` 管理多个 `container` 就非常的推荐。

2. 如下图展示了Pod网络所依赖的3个网络设备

    1. eth0是节点主机上的网卡，支持该节点流量出入的设备、也是支持集群节点间IP寻址和互通的设备；

    2. docker0是一个虚拟网桥，可以简单理解为一个虚拟交换机，支持该节点上的Pod之间进行IP寻址和互通的设备；

    3. veth0则是Pod1的虚拟网卡，支持该Pod内容器互通和对外访问的虚拟设备；

    4. docker0网桥和veth0网卡，都是linux支持和创建的虚拟网络设备；

    5. pause属于特殊容器，其运行的唯一目的是为Pod建立共享的veth0网络接口

  ![[k8s-nginx-pod.png]]
  

## 二、[deployment](https://kubernetes.io/zh-cn/docs/reference/kubernetes-api/workload-resources/deployment-v1/)、[StatefulSet](https://kubernetes.io/zh-cn/docs/reference/kubernetes-api/workload-resources/stateful-set-v1/)

### 1. 概要


1. Deployment 使得 Pod 和 ReplicaSet 能够进行声明式更新

2. StatefulSet 表示一组具有一致身份的 Pod：

    1. 身份定义为：

        - 网络：一个稳定的 DNS 和主机名。

        - 存储：根据要求提供尽可能多的 VolumeClaim。

        StatefulSet 保证给定的网络身份将始终映射到相同的存储身份。

        虽然pod完全具备在生产环境中部署独立的单体服务的能力，但在生产环境中，我们基本上不会直接管理 `pod`，我们会使用`deployment` 代为控管。延续上面的比喻就是将 `deployment` 视为一个好用的机房管理员：帮助我们进货，对pod进行开关机，对pod做系统升级和重装系统以实现功能升级和回滚。 `StatefulSet` 也相同，只不过每次它会保证一致性，而不像`deployment` 每次重启都是随机分配

### 2. 滚动升级


至于为什么需要 `deployment` 协助我们管理，可以参考下图了解一下滚动升级的流程，并想象一下自己手动操作pod的复杂度（使用 `kubectl get pods --watch` 可在终端中查看pod变化）：
![[k8s-pod-rollupdate.png]]
### 3. 分界线

        了解完以上信息就已经足够覆盖大多数开发需求，就如去网吧玩游戏、来公司上班，我们都不会去关注网络，而只关心游戏是否流畅输赢，工作进度是否顺畅。因为各个服务间的网络依赖就应该长久保持稳定，不宜做高频调整。除非出现问题，或者恰好我们需要重头搭建这部分，那么我们首先需要考虑的就是网络关系。

# Service资源
## [Service](https://kubernetes.io/zh-cn/docs/reference/kubernetes-api/service-resources/service-v1/)、[Ingress](https://kubernetes.io/zh-cn/docs/reference/kubernetes-api/service-resources/ingress-v1/)
### 1. 概要

1. Service 是软件服务（例如 mysql）的命名抽象，包含代理要侦听的本地端口（例如 3306）和一个选择算符，选择算符用来确定哪些 Pod 将响应通过代理发送的请求。
2. Ingress 是允许入站连接到达后端定义的端点的规则集合。Ingress 是允许入站连接到达后端定义的端点的规则集合。

        `Service` 就相当于给上述pod组成的服务插上了一条稳定的网线（当然不仅如此），使之可以通过网络通信，而 `Ingress` 则负责对外，相当于之前的web部署方案中 `nginx` 扮演的角色，将外部调用通过规则，将请求转发到相应的 `Service` 上。

### 2. Service网络原理

        首先我们熟悉DNS，再者我们知道通过 `deployment` 管理的pod每次重启都是重新生成、重新分配网络的，最后我们知道k8s是有一个


# 配置和存储资源

[ConfigMap](https://kubernetes.io/zh-cn/docs/reference/kubernetes-api/config-and-storage-resources/config-map-v1/)、[Secret](https://kubernetes.io/zh-cn/docs/reference/kubernetes-api/config-and-storage-resources/secret-v1/)、[Volume](https://kubernetes.io/zh-cn/docs/reference/kubernetes-api/config-and-storage-resources/volume/)

# 身份认证资源


[ServiceAccount](https://kubernetes.io/zh-cn/docs/reference/kubernetes-api/authentication-resources/service-account-v1/)


# 鉴权资源

  

[ClusterRole](https://kubernetes.io/zh-cn/docs/reference/kubernetes-api/authorization-resources/cluster-role-v1/)、[ClusterRoleBinding](https://kubernetes.io/zh-cn/docs/reference/kubernetes-api/authorization-resources/cluster-role-binding-v1/)

  

# 其他

  

1. [LimitRange](https://kubernetes.io/zh-cn/docs/reference/kubernetes-api/policy-resources/limit-range-v1/)、[NetworkPolicy](https://kubernetes.io/zh-cn/docs/reference/kubernetes-api/policy-resources/network-policy-v1/)

2. [Node](https://kubernetes.io/zh-cn/docs/reference/kubernetes-api/cluster-resources/node-v1/)、[Namespace](https://kubernetes.io/zh-cn/docs/reference/kubernetes-api/cluster-resources/namespace-v1/)

  

# 网络

  

**深入理解k8s 网络：**[https://www.jianshu.com/p/80eb2e9e32db](https://www.jianshu.com/p/80eb2e9e32db)

  

# 示意图

  

来源https://github.com/guangzhengli/k8s-tutorials

  

```jsx

kubectl get pods

# NAME                                   READY   STATUS    RESTARTS   AGE

# hellok8s-deployment-5d5545b69c-24lw5   1/1     Running   0          27m

# hellok8s-deployment-5d5545b69c-9g94t   1/1     Running   0          27m

# hellok8s-deployment-5d5545b69c-9gm8r   1/1     Running   0          27m

# nginx                                  1/1     Running   0          41m

  

kubectl get service

# NAME                         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE

# service-hellok8s-clusterip   ClusterIP   10.104.96.153   <none>        3000/TCP   10s

  

kubectl exec -it nginx-pod /bin/bash

# root@nginx-pod:/# curl 10.104.96.153:3000

# [v3] Hello, Kubernetes!, From host: hellok8s-deployment-5d5545b69c-9gm8r

# root@nginx-pod:/# curl 10.104.96.153:3000

#[v3] Hello, Kubernetes!, From host: hellok8s-deployment-5d5545b69c-9g94t

```


可以看到，我们多次 `curl 10.104.96.153:3000` 访问 `hellok8s` Service IP 地址，返回的 `hellok8s:v3` `hostname` 不一样，说明 Service 可以接收请求并将它们传递给它后面的所有 pod，还可以自动负载均衡。你也可以试试增加或者减少 `hellok8s:v3` pod 副本数量，观察 Service 的请求是否会动态变更。调用过程如下图所示：

### NodePort (负载均衡(略))

  

我们知道`kubernetes` 集群并不是单机运行，它管理着多台节点即 [Node](https://kubernetes.io/docs/concepts/architecture/nodes/)，可以通过每个节点上的 IP 和静态端口（`NodePort`）暴露服务。如下图所示，如果集群内有两台 Node 运行着 `hellok8s:v3`，我们创建一个 `NodePort` 类型的 Service，将 `hellok8s:v3` 的 `3000` 端口映射到 Node 机器的 `30000` 端口 (在 30000-32767 范围内)，就可以通过访问 `http://node1-ip:30000` 或者 `http://node2-ip:30000` 访问到服务。
![[k8s-svc-nodeport.png]]
  

Ingress
  ![[k8s-ingress.png]]