---
title: k8s
date: 2023-03-27 10:58:56
category:
  - note
  - k8s
  - docker
tags:
  - Linux
slug:
---

![k8s](https://d33wubrfki0l68.cloudfront.net/69e55f968a6f44613384615c6a78b881bfe28bd6/1600c/zh-cn/_common-resources/images/flower.svg)

# k8s学习

## 常用命令
- kubectl apply -f rcm_log_monut_k8s_pod.yaml
- kubectl get pod -A
- kubectl get pod -all-namespaces
- kubectl get node
- kubectl get deploy
- [持久卷 - PersistentVolume](#持久卷)
    - kubectl get persistentvolume
    - kubectl describe persistentvolume example-pv
    - `kubectl **delete** persistentvolume example-pv`
- 从kubectl cp -n <命名空间> -c <NAMEC> <PODNAME>:xxx.json xxx.json

## configmap / secret 存储文件内容
`sftpkey` 为名称
### 新建
```bash
kubectl create secret generic sftpkey --from-file=/etc/id_rsa
# kubectl create -n {NAMESPACE} secret generic sftpkey --from-file=/etc/id_rsa
```

### 删除
kubectl delete secret sftpkey


## 常用字段

下面是一些 Kubernetes 中常用的配置字段：

```
apiVersion： Kubernetes API 的版本，用于定义资源的 API 版本号。
kind： 资源的类型，比如 Pod、Deployment、Service 等。
metadata： 元数据字段，用于存储 Kubernetes 对象的名称、命名空间、标签等信息。
spec： 对象的规格，用于定义对象的期望状态，如 Pod 的容器、Service 的端口等。
status： 对象的状态，用于记录对象的实际状态，如 Pod 的运行状态、Service 的访问地址等。
```

另外还有一些常用的子字段，如：

```
containers： Pod 中的容器定义，包括容器名称、镜像、命令、参数等。
ports： Service 中的端口定义，包括端口名称、协议、端口号、目标端口号等。
selector： Service 中用于选择后端 Pod 的标签选择器。
replicas： Deployment 中期望的副本数。
template： Deployment 中用于创建 Pod 的 PodTemplateSpec 定义。
```

## 其他

在 Kubernetes 中，annotations 字段是资源对象中的一个元数据字段，用于存储一些非标准化的元数据信息。与 metadata 字段中的标准化信息不同，annotations 字段中存储的信息往往是自定义的、不易归类的数据，比如代码库的提交 ID、配置文件的 MD5 校验值、外部系统的关联信息等等。

### annotations

字段的格式为一个 key-value 对的列表，其中 key 表示注解的名称，value 表示注解的值。例如：

```yaml
apiVersion: v1
kind: Pod
metadata:
	name: my-pod
	annotations:
		commit-id: abc123
spec:
	containers:
	- name: my-container
		image: my-image
```

在这个示例中，我们在 Pod 的 metadata 中添加了一个自定义注解 commit-id，并将其值设置为 abc123。这个注解表示当前 Pod 对应的代码库的提交 ID。

需要注意的是，由于 annotations 字段是用于存储自定义元数据信息的，因此在使用时需要注意避免与其他标准化的字段发生冲突，以免产生意外的后果。同时，由于注解的值可以是任意字符串，因此需要对注解的内容进行适当的验证和转义，以避免安全风险

### ownerReferences 字段

在 Kubernetes 中，ownerReferences 字段是资源对象中的一个元数据字段，用于指定当前对象的所有者（owner）。这个字段可以用来建立资源对象之间的父子关系，便于管理和垃圾回收。在一个资源对象中，可以同时指定多个父对象（owner）。

ownerReferences 字段的格式为一个包含多个 ownerReference 对象的列表。每个 ownerReference 对象表示一个父对象的引用，其中包含了父对象的 API 版本、资源类型、名称和 UID。例如：

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
  ownerReferences:
  - apiVersion: apps/v1
    kind: Deployment
    name: my-deployment
    uid: abc123
  - apiVersion: apps/v1
    kind: ReplicaSet
    name: my-replicaset
    uid: def456
spec:
  containers:
  - name: my-container
    image: my-image
```

```yaml
这段 YAML 文件描述了一个名为 my-pod 的 Pod 对象，它有两个父对象，分别是一个 Deployment 和一个 ReplicaSet。其中，Deployment 的名称为 my-deployment，UID 为 abc123，ReplicaSet 的名称为 my-replicaset，UID 为 def456。
该 Pod 中只包含一个容器，名称为 my-container，使用镜像为 my-image。
需要注意的是，这个 Pod 对象的 ownerReferences 字段表示它是 Deployment 和 ReplicaSet 的子对象，当这两个父对象被删除时，该 Pod 对象也会被自动删除。另外，这个 Pod 对象和其父对象都属于同一个命名空间，因为没有在 metadata 中指定 namespace 字段
```

在这个示例中，我们在 Pod 的 metadata 中添加了两个父对象，分别是一个 Deployment 和一个 ReplicaSet。这些信息可以帮助 Kubernetes 更好地管理这些对象之间的依赖关系，便于进行垃圾回收和版本控制。

需要注意的是，ownerReferences 字段中的对象必须是同一个命名空间中的资源对象，否则会引发错误。另外，在使用 ownerReferences 字段时需要注意避免循环引用的问题，以免产生意外的后果。

### ownerReferences 中的name和该pod name相同有什么作用？

在 Kubernetes 中，如果一个资源对象的 ownerReferences 中的 name 字段与当前对象的 metadata 中的 name 字段相同，表示当前对象是父对象（owner）自己创建的。这种情况下，父对象的控制器不会对这个对象进行垃圾回收，因为这个对象本身就是父对象的一部分。

例如，在一个 Deployment 中创建了一个 Pod，并且将 Pod 的 ownerReferences 中的 name 字段设置为 Pod 的名称。这样一来，当 Deployment 被删除时，由于 Pod 依赖于 Deployment，Kubernetes 会先删除 Deployment，然后再删除 Pod。在删除 Pod 时，由于 Pod 的 ownerReferences 中的 name 字段与 Pod 的 metadata 中的 name 字段相同，所以控制器不会对 Pod 进行垃圾回收，而是保留下来作为 Deployment 的一部分。

通过这种方式，我们可以在 Kubernetes 中建立资源对象之间更加复杂的关系，实现更高级别的控制和管理。例如，可以通过设置 ownerReferences 字段来建立 Deployment 和 Service 的关系，从而实现负载均衡和服务发现。

### env 环境变量

```yaml
spec:
  containers:
  - env:
    - name: POD_IP_ADDRESS
      valueFrom:
        fieldRef:
          apiVersion: v1
          fieldPath: status.podIP
    - name: POD_OWN_NAME
      valueFrom:
        fieldRef:
          apiVersion: v1
          fieldPath: metadata.name
    - name: POD_OWN_NAMESPACE
      valueFrom:
        fieldRef:
          apiVersion: v1
          fieldPath: metadata.namespace
```

这段 YAML 文件描述了一个 Pod 中的三个环境变量。这些环境变量的值是从 Kubernetes 中获取的，而不是直接在 Pod 中指定的。

其中，POD_IP_ADDRESS 环境变量的值使用了 valueFrom 字段，并指定了一个 fieldRef，用于从当前 Pod 的状态中获取 podIP 字段的值。POD_IP_ADDRESS 环境变量的值就是当前 Pod 的 IP 地址。

POD_OWN_NAME 和 POD_OWN_NAMESPACE 环境变量的值也使用了 valueFrom 字段，并指定了一个 fieldRef，用于从当前 Pod 的元数据中获取 name 和 namespace 字段的值。POD_OWN_NAME 环境变量的值就是当前 Pod 的名称，POD_OWN_NAMESPACE 环境变量的值就是当前 Pod 所属的命名空间。

这种方式可以让我们在定义 Pod 时，动态地获取 Pod 自身的元数据和状态信息，并将这些信息作为环境变量传递给 Pod 中的容器。在容器中，我们可以通过读取这些环境变量的值，来获取当前 Pod 的一些重要信息

### initContainers

```yaml
dnsPolicy: ClusterFirst
  enableServiceLinks: true
  initContainers:
  - command:
    - sh
    - -c
    - until nc -zvw3 hello-redis-svc.hello-prod.svc.cluster.local 6379; do echo Waiting
      hello-redis; sleep 5; done;
    image: xxxx.docker.io/hello-docker/busybox:1.28.1
    imagePullPolicy: IfNotPresent
    name: init-redis
    resources: {}
    terminationMessagePath: /dev/termination-log
    terminationMessagePolicy: File
    volumeMounts:
    - mountPath: /var/run/secrets/kubernetes.io/serviceaccount
      name: kube-api-access-pp4tg
      readOnly: true
  - command:
    - sh
    - -c
    - until nc -zvw3 hello-mongodb-svc.hello.svc.cluster.local 27017; do echo Waiting
      hello-mongodb; sleep 5; done;
    image: xxxx.docker.io/hello-docker/busybox:1.28.1
    imagePullPolicy: IfNotPresent
    name: init-mongodb
    resources: {}
    terminationMessagePath: /dev/termination-log
    terminationMessagePolicy: File
    volumeMounts:
    - mountPath: /var/run/secrets/kubernetes.io/serviceaccount
      name: kube-api-access-pp4tg
      readOnly: true
```

- 这段 YAML 配置是关于 Kubernetes 中的初始化容器（initContainers）的。
- 初始化容器是在 Pod 中所有容器启动之前运行的容器，用于预处理或准备容器的某些方面。
- 在这个 YAML 配置中，定义了两个初始化容器 `init-redis` 和 `init-mongodb`，分别检查 hello-redis 和 hello-mongodb 是否准备就绪。具体地，这两个初始化容器在容器内运行了一个 until 循环，每 5 秒尝试连接 hello-redis 或 hello-mongodb 服务，并打印 Waiting hello-redis 或 Waiting hello-mongodb 的日志信息。如果连接成功，则退出循环，容器初始化成功。初始化容器的镜像是 `xxxx.docker.io/hello-docker/busybox:1.28.1`，使用 IfNotPresent 策略拉取镜像。其中 `resources` 字段定义了该容器的资源限制和请求，`volumeMounts` 字段定义了将哪些存储卷挂载到该容器的哪些路径。


### 一些杂项

- nodeName: Pod所要调度的节点名称。
- nodeSelector: 用于指定Pod所需的标签，使Pod只能被具有特定标签的节点调度。
- preemptionPolicy: Pod优先级抢占策略。如果当前节点资源不足，可以抢占优先级低的Pod来为优先级高的Pod腾出资源。PreemptLowerPriority表示低优先级的Pod可以被抢占。
- priority: Pod的优先级，数值越高表示优先级越高。
- restartPolicy: Pod的重启策略，可以是Always、OnFailure或Never。Always表示Pod一旦终止就会自动重启，OnFailure表示只有在非0退出码时才会重启，Never表示不会自动重启。
- schedulerName: 指定Pod使用的调度器。
- securityContext: Pod的安全上下文。
- serviceAccount: 默认使用的服务账户。
- serviceAccountName: 指定使用的服务账户名称。
- terminationGracePeriodSeconds: Pod终止的优雅期，即Pod终止时等待多长时间后强制终止。默认为30秒
- 其余一些状态信息 `status` : `podIPs` `phase: Running` `phase` `initContainerStatuses` `containerStatuses` `containerStatuses` `conditions`

##  <a name="持久卷">持久卷 - PersistentVolume</a>

需要注意的是，`PersistentVolume`
 是一个集群级别的资源，不属于任何一个命名空间，但可以通过在 `metadata`
 字段中指定 `namespace`
 字段来将其关联到某个命名空间中。这个关联只是用来方便查找和管理资源，不会对 `PersistentVolume`
 对象本身产生影响。

## 知识问答
### 1. nodeSelector 和 nodeSelectorTerms 有什么区别？
> ChatGPT:

- 在 Kubernetes 中，nodeSelector 和 nodeSelectorTerms 都是用来选择哪些节点可以运行 Pod 的。
- nodeSelector 是 PodSpec 中的一个字段，它用于指定一个键值对，只有运行在具有指定标签的节点上的 Pod 才会被调度到该节点上。例如：
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  nodeSelector:
    kubernetes.io/hostname: node-1
  containers:
    - name: my-container
      image: my-image
```

在上面的示例中，nodeSelector 字段指定了 Pod 只能调度到具有标签 kubernetes.io/hostname=node-1 的节点上。
而 nodeSelectorTerms 是一个更高级别的机制，它允许在一个 Pod 中指定多个选择条件。例如：
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  nodeSelector:
    matchExpressions:
      - {key: zone, operator: In, values: [east, west]}
      - {key: region, operator: NotIn, values: [us-east-1]}
    matchLabels:
      environment: production
  containers:
    - name: my-container
      image: my-image
```
在上面的示例中，nodeSelector 字段指定了多个选择条件。其中 matchExpressions 指定了两个表达式，一个是 zone 标签的值必须是 east 或 west，另一个是 region 标签的值不能是 us-east-1。而 matchLabels 指定了 environment 标签的值必须是 production。

因此，nodeSelector 只能指定一个选择条件，而 nodeSelectorTerms 可以指定多个选择条件。\



## 常用命令

- kubectl apply -f rcm_log_monut_k8s_pod.yaml
- [持久卷 - PersistentVolume](https://www.notion.so/PersistentVolume-2db6a82d152c4f0ba3659d4bfb27b883?pvs=21)
    - kubectl get persistentvolume
    - kubectl describe persistentvolume example-pv
    - `kubectl **delete** persistentvolume example-pv`

## 常用字段

下面是一些 Kubernetes 中常用的配置字段：

```
apiVersion： Kubernetes API 的版本，用于定义资源的 API 版本号。
kind： 资源的类型，比如 Pod、Deployment、Service 等。
metadata： 元数据字段，用于存储 Kubernetes 对象的名称、命名空间、标签等信息。
spec： 对象的规格，用于定义对象的期望状态，如 Pod 的容器、Service 的端口等。
status： 对象的状态，用于记录对象的实际状态，如 Pod 的运行状态、Service 的访问地址等。
```

另外还有一些常用的子字段，如：

```
containers： Pod 中的容器定义，包括容器名称、镜像、命令、参数等。
ports： Service 中的端口定义，包括端口名称、协议、端口号、目标端口号等。
selector： Service 中用于选择后端 Pod 的标签选择器。
replicas： Deployment 中期望的副本数。
template： Deployment 中用于创建 Pod 的 PodTemplateSpec 定义。
```

## 其他

在 Kubernetes 中，annotations 字段是资源对象中的一个元数据字段，用于存储一些非标准化的元数据信息。与 metadata 字段中的标准化信息不同，annotations 字段中存储的信息往往是自定义的、不易归类的数据，比如代码库的提交 ID、配置文件的 MD5 校验值、外部系统的关联信息等等。

### annotations

字段的格式为一个 key-value 对的列表，其中 key 表示注解的名称，value 表示注解的值。例如：

```yaml
apiVersion: v1
kind: Pod
metadata:
	name: my-pod
	annotations:
		commit-id: abc123
spec:
	containers:
	- name: my-container
		image: my-image
```

在这个示例中，我们在 Pod 的 metadata 中添加了一个自定义注解 commit-id，并将其值设置为 abc123。这个注解表示当前 Pod 对应的代码库的提交 ID。

需要注意的是，由于 annotations 字段是用于存储自定义元数据信息的，因此在使用时需要注意避免与其他标准化的字段发生冲突，以免产生意外的后果。同时，由于注解的值可以是任意字符串，因此需要对注解的内容进行适当的验证和转义，以避免安全风险

### ownerReferences 字段

在 Kubernetes 中，ownerReferences 字段是资源对象中的一个元数据字段，用于指定当前对象的所有者（owner）。这个字段可以用来建立资源对象之间的父子关系，便于管理和垃圾回收。在一个资源对象中，可以同时指定多个父对象（owner）。

ownerReferences 字段的格式为一个包含多个 ownerReference 对象的列表。每个 ownerReference 对象表示一个父对象的引用，其中包含了父对象的 API 版本、资源类型、名称和 UID。例如：

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
  ownerReferences:
  - apiVersion: apps/v1
    kind: Deployment
    name: my-deployment
    uid: abc123
  - apiVersion: apps/v1
    kind: ReplicaSet
    name: my-replicaset
    uid: def456
spec:
  containers:
  - name: my-container
    image: my-image
```

```yaml
这段 YAML 文件描述了一个名为 my-pod 的 Pod 对象，它有两个父对象，分别是一个 Deployment 和一个 ReplicaSet。其中，Deployment 的名称为 my-deployment，UID 为 abc123，ReplicaSet 的名称为 my-replicaset，UID 为 def456。
该 Pod 中只包含一个容器，名称为 my-container，使用镜像为 my-image。
需要注意的是，这个 Pod 对象的 ownerReferences 字段表示它是 Deployment 和 ReplicaSet 的子对象，当这两个父对象被删除时，该 Pod 对象也会被自动删除。另外，这个 Pod 对象和其父对象都属于同一个命名空间，因为没有在 metadata 中指定 namespace 字段
```

在这个示例中，我们在 Pod 的 metadata 中添加了两个父对象，分别是一个 Deployment 和一个 ReplicaSet。这些信息可以帮助 Kubernetes 更好地管理这些对象之间的依赖关系，便于进行垃圾回收和版本控制。

需要注意的是，ownerReferences 字段中的对象必须是同一个命名空间中的资源对象，否则会引发错误。另外，在使用 ownerReferences 字段时需要注意避免循环引用的问题，以免产生意外的后果。

### ownerReferences 中的name和该pod name相同有什么作用？

在 Kubernetes 中，如果一个资源对象的 ownerReferences 中的 name 字段与当前对象的 metadata 中的 name 字段相同，表示当前对象是父对象（owner）自己创建的。这种情况下，父对象的控制器不会对这个对象进行垃圾回收，因为这个对象本身就是父对象的一部分。

例如，在一个 Deployment 中创建了一个 Pod，并且将 Pod 的 ownerReferences 中的 name 字段设置为 Pod 的名称。这样一来，当 Deployment 被删除时，由于 Pod 依赖于 Deployment，Kubernetes 会先删除 Deployment，然后再删除 Pod。在删除 Pod 时，由于 Pod 的 ownerReferences 中的 name 字段与 Pod 的 metadata 中的 name 字段相同，所以控制器不会对 Pod 进行垃圾回收，而是保留下来作为 Deployment 的一部分。

通过这种方式，我们可以在 Kubernetes 中建立资源对象之间更加复杂的关系，实现更高级别的控制和管理。例如，可以通过设置 ownerReferences 字段来建立 Deployment 和 Service 的关系，从而实现负载均衡和服务发现。

### env 环境变量

```yaml
spec:
  containers:
  - env:
    - name: POD_IP_ADDRESS
      valueFrom:
        fieldRef:
          apiVersion: v1
          fieldPath: status.podIP
    - name: POD_OWN_NAME
      valueFrom:
        fieldRef:
          apiVersion: v1
          fieldPath: metadata.name
    - name: POD_OWN_NAMESPACE
      valueFrom:
        fieldRef:
          apiVersion: v1
          fieldPath: metadata.namespace
```

这段 YAML 文件描述了一个 Pod 中的三个环境变量。这些环境变量的值是从 Kubernetes 中获取的，而不是直接在 Pod 中指定的。

其中，POD_IP_ADDRESS 环境变量的值使用了 valueFrom 字段，并指定了一个 fieldRef，用于从当前 Pod 的状态中获取 podIP 字段的值。POD_IP_ADDRESS 环境变量的值就是当前 Pod 的 IP 地址。

POD_OWN_NAME 和 POD_OWN_NAMESPACE 环境变量的值也使用了 valueFrom 字段，并指定了一个 fieldRef，用于从当前 Pod 的元数据中获取 name 和 namespace 字段的值。POD_OWN_NAME 环境变量的值就是当前 Pod 的名称，POD_OWN_NAMESPACE 环境变量的值就是当前 Pod 所属的命名空间。

这种方式可以让我们在定义 Pod 时，动态地获取 Pod 自身的元数据和状态信息，并将这些信息作为环境变量传递给 Pod 中的容器。在容器中，我们可以通过读取这些环境变量的值，来获取当前 Pod 的一些重要信息

### initContainers

```yaml
dnsPolicy: ClusterFirst
  enableServiceLinks: true
  initContainers:
  - command:
    - sh
    - -c
    - until nc -zvw3 bsa-redis-svc.bsa-prod.svc.cluster.local 6379; do echo Waiting
      BSA-redis; sleep 5; done;
    image: repos-wh.inone.nsfocus.com/bsa-3rd-docker/busybox:1.28.1
    imagePullPolicy: IfNotPresent
    name: init-redis
    resources: {}
    terminationMessagePath: /dev/termination-log
    terminationMessagePolicy: File
    volumeMounts:
    - mountPath: /var/run/secrets/kubernetes.io/serviceaccount
      name: kube-api-access-pp4tg
      readOnly: true
  - command:
    - sh
    - -c
    - until nc -zvw3 bsa-mongodb-svc.bsa-paas.svc.cluster.local 27017; do echo Waiting
      BSA-mongodb; sleep 5; done;
    image: repos-wh.inone.nsfocus.com/bsa-3rd-docker/busybox:1.28.1
    imagePullPolicy: IfNotPresent
    name: init-mongodb
    resources: {}
    terminationMessagePath: /dev/termination-log
    terminationMessagePolicy: File
    volumeMounts:
    - mountPath: /var/run/secrets/kubernetes.io/serviceaccount
      name: kube-api-access-pp4tg
      readOnly: true
```

- 这段 YAML 配置是关于 Kubernetes 中的初始化容器（initContainers）的。
- 初始化容器是在 Pod 中所有容器启动之前运行的容器，用于预处理或准备容器的某些方面。
- 在这个 YAML 配置中，定义了两个初始化容器 `init-redis` 和 `init-mongodb`，分别检查 BSA-redis 和 BSA-mongodb 是否准备就绪。具体地，这两个初始化容器在容器内运行了一个 until 循环，每 5 秒尝试连接 BSA-redis 或 BSA-mongodb 服务，并打印 Waiting BSA-redis 或 Waiting BSA-mongodb 的日志信息。如果连接成功，则退出循环，容器初始化成功。初始化容器的镜像是 `repos-wh.inone.nsfocus.com/bsa-3rd-docker/busybox:1.28.1`，使用 IfNotPresent 策略拉取镜像。其中 `resources` 字段定义了该容器的资源限制和请求，`volumeMounts` 字段定义了将哪些存储卷挂载到该容器的哪些路径。

[scancenter - init项目](https://www.notion.so/71d149949ede4a86a3aa954c7569aa34?pvs=21)

### 一些杂项

- nodeName: Pod所要调度的节点名称。
- nodeSelector: 用于指定Pod所需的标签，使Pod只能被具有特定标签的节点调度。
- preemptionPolicy: Pod优先级抢占策略。如果当前节点资源不足，可以抢占优先级低的Pod来为优先级高的Pod腾出资源。PreemptLowerPriority表示低优先级的Pod可以被抢占。
- priority: Pod的优先级，数值越高表示优先级越高。
- restartPolicy: Pod的重启策略，可以是Always、OnFailure或Never。Always表示Pod一旦终止就会自动重启，OnFailure表示只有在非0退出码时才会重启，Never表示不会自动重启。
- schedulerName: 指定Pod使用的调度器。
- securityContext: Pod的安全上下文。
- serviceAccount: 默认使用的服务账户。
- serviceAccountName: 指定使用的服务账户名称。
- terminationGracePeriodSeconds: Pod终止的优雅期，即Pod终止时等待多长时间后强制终止。默认为30秒
- 其余一些状态信息 `status` : `podIPs` `phase: Running` `phase` `initContainerStatuses` `containerStatuses` `containerStatuses` `conditions`

## 持久卷 - PersistentVolume

需要注意的是，`PersistentVolume`  是一个集群级别的资源，不属于任何一个命名空间，但可以通过在 `metadata`  字段中指定 `namespace`  字段来将其关联到某个命名空间中。这个关联只是用来方便查找和管理资源，不会对 `PersistentVolume`  对象本身产生影响。

# service

### k8s 路由解析

"host": "choi-wan-rabbitmq.nscloud.svc.cluster.local" 解释这段k8s配置

4/24/2023, 5:36:06 PM

这段 Kubernetes（k8s）配置中的 "host": "choi-wan-rabbitmq.nscloud.svc.cluster.local" 是一个应用程序连接到 RabbitMQ 消息代理服务的主机地址。具体来说，它是一个 Kubernetes 集群内部的服务地址，该服务被命名为 choi-wan-rabbitmq，并位于 nscloud 命名空间的 svc（Service）资源中。

如果应用程序需要连接到 [scan.rabbitmq.ros.nsfocus.com](http://scan.rabbitmq.ros.nsfocus.com/) 上运行的 RabbitMQ 服务，则需要在 Kubernetes 中创建一个外部服务或使用 Kubernetes 的 DNS 解析功能将该主机名映射到 RabbitMQ 服务的 IP 地址。

4/24/2023, 5:54:22 PM

svc.cluster.local 分别代表什么？

4/24/2023, 5:54:40 PM

在 Kubernetes 中，svc.cluster.local 是一个特殊的域名后缀，用于将服务名称解析为集群内部的 IP 地址。具体来说，svc 代表 Kubernetes 中的 Service 资源类型，cluster.local 是 Kubernetes 集群的默认域名后缀。因此，当应用程序需要连接到 Kubernetes 集群中的服务时，可以使用该服务的名称作为主机名，并在末尾添加 svc.cluster.local 后缀来获得服务的 IP 地址。例如，在上述例子中，choi-wan-rabbitmq.nscloud.svc.cluster.local 是 choi-wan-rabbitmq 服务的完整域名，它将被解析为 RabbitMQ 消息代理服务的 IP 地址，从而使应用程序能够与该服务进行通信。

### 配置一个rabbitmq给大家用

在k8s 新建一个公共rabbitmq供所有pod使用应该如何操作？

4/24/2023, 5:34:27 PM

在 Kubernetes 中创建一个共享的 RabbitMQ 服务供所有 Pod 使用，需要以下步骤：

1. 创建 RabbitMQ 镜像：可以使用 Dockerfile 或者从 Docker Hub 下载现成的 RabbitMQ 镜像。
2. 配置 RabbitMQ：修改 RabbitMQ 的配置文件，包括默认用户名和密码、端口号、虚拟主机等。
3. 创建 Kubernetes Service：使用 Kubernetes 的 Service 资源类型来创建一个 RabbitMQ 服务，这个服务会为 RabbitMQ 提供一个稳定的 IP 地址和端口。可以选择 ClusterIP、LoadBalancer 或者 NodePort 类型的服务。
4. 创建 Kubernetes Deployment：创建一个 RabbitMQ 的 Deployment 资源，用于实例化 RabbitMQ 的容器，并且将这个资源归属到刚才创建的 Service 上，确保所有的 Pod 都可以访问到 RabbitMQ 服务。
5. 验证 RabbitMQ 是否可用：使用 Kubernetes Dashboard 或者 kubectl 命令行工具，连接到 RabbitMQ 服务进行验证，确保它能够正常工作。
6. 在其他的 Kubernetes Pod 中使用 RabbitMQ：在其他的 Pod 中安装 RabbitMQ 客户端，并使用 Service 的 IP 和端口访问 RabbitMQ 服务，实现 Pod 之间的消息传递。

总体来说，创建共享的 RabbitMQ 服务需要在 Kubernetes 中创建一个带有自动伸缩功能的 Deployment，并将它绑定到一个稳定的 Service 上，然后在其他的 Pod 中使用 RabbitMQ 客户端来连接该服务。

4/24/2023, 5:34:49 PM

请提供一下上述所需的示例yaml文件内容

4/24/2023, 5:35:52 PM

以下是创建共享的 RabbitMQ 服务所需的示例 YAML 文件内容：

1. RabbitMQ 镜像的 YAML 文件内容如下：

```
复制代码
apiVersion: v1
kind: Pod
metadata:
  name: rabbitmq-pod
spec:
  containers:
  - name: rabbitmq
    image: rabbitmq
    ports:
    - containerPort: 5672
      name: amqp
    - containerPort: 15672
      name: http

```

注意，这里使用的是 Docker Hub 上的默认 RabbitMQ 镜像，也可以根据需要自定义 Dockerfile 来构建。

1. RabbitMQ 配置文件的 YAML 文件内容如下：

```
复制代码
apiVersion: v1
kind: ConfigMap
metadata:
  name: rabbitmq-config
data:
  rabbitmq.conf: |
    loopback_users.guest = false
    listeners.tcp.default = 5672
    management.listener.port = 15672
  enabled_plugins: |
    [rabbitmq_management].

```

这里使用 ConfigMap 来存储 RabbitMQ 的配置信息。配置文件中禁用了默认用户 guest，开启了 TCP 监听端口和管理界面端口，并且启用了 RabbitMQ 管理插件。

1. RabbitMQ Service 的 YAML 文件内容如下：

```
复制代码
apiVersion: v1
kind: Service
metadata:
  name: rabbitmq-service
spec:
  selector:
    app: rabbitmq
  ports:
  - name: amqp
    port: 5672
    targetPort: amqp
  - name: http
    port: 15672
    targetPort: http
  type: ClusterIP

```

这里创建的是 ClusterIP 类型的 Service，它会为 RabbitMQ 提供一个稳定的 IP 地址和端口。

1. RabbitMQ Deployment 的 YAML 文件内容如下：

```
复制代码
apiVersion: apps/v1
kind: Deployment
metadata:
  name: rabbitmq-deployment
spec:
  selector:
    matchLabels:
      app: rabbitmq
  replicas: 1
  template:
    metadata:
      labels:
        app: rabbitmq
    spec:
      volumes:
      - name: rabbitmq-config-volume
        configMap:
          name: rabbitmq-config
      containers:
      - name: rabbitmq
        image: rabbitmq
        ports:
        - containerPort: 5672
          name: amqp
        - containerPort: 15672
          name: http
        volumeMounts:
        - name: rabbitmq-config-volume
          mountPath: /etc/rabbitmq/

```

这里创建了一个带有自动伸缩功能的 Deployment，并将其绑定到刚才创建的 Service 上。Deployment 中指定了 Pod 的标签，通过 ConfigMap 挂载了 RabbitMQ 的配置文件，确保所有的 Pod 都可以访问到 RabbitMQ 服务。

1. 验证 RabbitMQ 是否可用的 YAML 文件内容如下：

```
复制代码
apiVersion: v1
kind: Pod
metadata:
  name: rabbitmq-client-pod
spec:
  containers:

```

4/24/2023, 5:36:17 PM

继续

4/24/2023, 5:37:21 PM

以下是创建共享的 RabbitMQ 服务所需的示例 YAML 文件内容：

1. RabbitMQ 镜像的 YAML 文件内容如下：

```
复制代码
apiVersion: v1
kind: Pod
metadata:
  name: rabbitmq-pod
spec:
  containers:
  - name: rabbitmq
    image: rabbitmq
    ports:
    - containerPort: 5672
      name: amqp
    - containerPort: 15672
      name: http

```

注意，这里使用的是 Docker Hub 上的默认 RabbitMQ 镜像，也可以根据需要自定义 Dockerfile 来构建。

1. RabbitMQ 配置文件的 YAML 文件内容如下：

```
复制代码
apiVersion: v1
kind: ConfigMap
metadata:
  name: rabbitmq-config
data:
  rabbitmq.conf: |
    loopback_users.guest = false
    listeners.tcp.default = 5672
    management.listener.port = 15672
  enabled_plugins: |
    [rabbitmq_management].

```

这里使用 ConfigMap 来存储 RabbitMQ 的配置信息。配置文件中禁用了默认用户 guest，开启了 TCP 监听端口和管理界面端口，并且启用了 RabbitMQ 管理插件。

1. RabbitMQ Service 的 YAML 文件内容如下：

```
复制代码
apiVersion: v1
kind: Service
metadata:
  name: rabbitmq-service
spec:
  selector:
    app: rabbitmq
  ports:
  - name: amqp
    port: 5672
    targetPort: amqp
  - name: http
    port: 15672
    targetPort: http
  type: ClusterIP

```

这里创建的是 ClusterIP 类型的 Service，它会为 RabbitMQ 提供一个稳定的 IP 地址和端口。

1. RabbitMQ Deployment 的 YAML 文件内容如下：

```
复制代码
apiVersion: apps/v1
kind: Deployment
metadata:
  name: rabbitmq-deployment
spec:
  selector:
    matchLabels:
      app: rabbitmq
  replicas: 1
  template:
    metadata:
      labels:
        app: rabbitmq
    spec:
      volumes:
      - name: rabbitmq-config-volume
        configMap:
          name: rabbitmq-config
      containers:
      - name: rabbitmq
        image: rabbitmq
        ports:
        - containerPort: 5672
          name: amqp
        - containerPort: 15672
          name: http
        volumeMounts:
        - name: rabbitmq-config-volume
          mountPath: /etc/rabbitmq/

```

这里创建了一个带有自动伸缩功能的 Deployment，并将其绑定到刚才创建的 Service 上。Deployment 中指定了 Pod 的标签，通过 ConfigMap 挂载了 RabbitMQ 的配置文件，确保所有的 Pod 都可以访问到 RabbitMQ 服务。

1. 验证 RabbitMQ 是否可用的 YAML 文件内容如下：

```
复制代码
apiVersion: v1
kind: Pod
metadata:
  name: rabbitmq-client-pod
spec:
  containers:
  - name: rabbitmq-client
    image: rabbitmq
    command: ["rabbitmqctl", "list_users"]

```

这里创建了一个 Pod 来验证 RabbitMQ 是否可用，使用 rabbitmqctl 命令列出用户列表来检查服务是否正常工作。

## ingress

### 配置

- k8s kind ingress 是什么，有什么用途？

[K8s Ingress 是 Kubernetes 集群中的一个资源对象，定义了一系列路由转发规则（或反向代理规则），规定了外部进来的 HTTP/HTTPS 请求应该被转发到哪个 Service 上。Ingress Controller 相当于是一个反向代理程序，负责解析 Ingress 的反向代理规则，并实时感知 Ingress 转发规则的变化。一旦 Ingress 规则有变化，Ingress Controller 会及时更新自己相应的转发规则，并根据这些规则，将接收到的请求转发到对应的 Service。](https://blog.csdn.net/weixin_36755535/article/details/128385135)[1](https://bing.com/search?q=k8s+kind+ingress+%E6%98%AF%E4%BB%80%E4%B9%88)[2](https://blog.csdn.net/weixin_36755535/article/details/128385135)

[Ingress 可以提供负载均衡、SSL 终结和基于名称的虚拟托管等功能。](https://kubernetes.io/zh/docs/concepts/services-networking/ingress/)

- 举例说明。假设k8s中有一个服务A需要访问k8s中另一个服务B应该如何通过ingress 来实现

假设你的 Kubernetes 集群中有一个服务 A，需要访问另一个服务 B，可以通过 Ingress 来实现。首先，你需要创建一个 Ingress 资源对象，定义外部对集群内服务的访问路由。例如：

```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: minimal-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - http:
      paths:
      - path: /testpath
        pathType: Prefix
        backend:
          service:
            name: test
            port:
              number: 80

```

这个 Ingress 对象将会把 `/testpath` 的请求转发到名为 `test` 的 Service 上。这个 Service 可以是服务 B。[1](https://bing.com/search?q=k8s+ingress+%E4%B8%BE%E4%BE%8B)

希望这些信息能够帮助你理解如何通过 Ingress 实现服务 A 访问服务 B。如果你还有其他问题，请随时问我。

## 环境变量在k8s

- k8s设定环境变量
    
    [根据搜索结果，k8s设定环境变量的方法有以下几种1](https://kubernetes.io/zh/docs/tasks/inject-data-application/define-environment-variable-container/)[2](https://www.cnblogs.com/qsing/p/15773745.html)：
    
    - 在Pod的yaml文件中，使用env字段为容器指定环境变量，例如：
    
    ```
    apiVersion: v1
    kind: Pod
    metadata:
      name: envar-demo
    spec:
      containers:
      - name: envar-demo-container
        image: nginx
        env:
        - name: DEMO_GREETING
          value: "Hello from the environment"
        - name: DEMO_FAREWELL
          value: "Such a sweet sorrow"
    
    ```
    
    - 使用ConfigMap或Secret对象来存储环境变量的值，然后在Pod的yaml文件中，使用envFrom字段或valueFrom字段来引用这些对象，例如：
    
    ```
    apiVersion: v1
    kind: Pod
    metadata:
      name: dapi-test-pod
    spec:
      containers:
        - name: test-container
          image: k8s.gcr.io/busybox
          command: [ "/bin/sh", "-c", "env" ]
          env:
            # Define the environment variable
            - name: SPECIAL_LEVEL_KEY
              valueFrom:
                configMapKeyRef:
                  # The ConfigMap containing the value you want to assign to SPECIAL_LEVEL_KEY
                  name: special-config
                  # Specify the key associated with the value
                  key: special.how
    
    ```
    
- 使用env字段为容器指定环境变量 和 使用ConfigMap或Secret对象来存储环境变量 有什么区别？
    
    [根据搜索结果，使用env字段为容器指定环境变量和使用ConfigMap或Secret对象来存储环境变量的区别主要有以下几点1](https://www.cnblogs.com/qsing/p/15773745.html)[2](https://cloud.tencent.com/developer/article/1931098)[3](https://kubernetes.io/zh/docs/tasks/inject-data-application/define-environment-variable-container/)：
    
    - 使用env字段时，需要为每个容器指定每个环境变量的值，而使用ConfigMap或Secret对象时，可以一次性引用所有的键值对作为环境变量
    - 使用env字段时，环境变量的值是直接写在Pod的yaml文件中的，而使用ConfigMap或Secret对象时，环境变量的值是存储在Etcd中的，这样可以更好地管理和保护配置信息
    - 使用env字段时，如果需要修改环境变量的值，需要重新创建Pod，而使用ConfigMap或Secret对象时，可以动态更新环境变量的值，不需要重启Pod

## ConfigMap

- ConfigMap对象是一个存储配置数据的API对象
    
    ```jsx
    volumes:
      - configMap:
          defaultMode: 420
          items:
          - key: env.json
            path: env.json
          name: env-config
        name: env-config
    ```
    
    在这个配置中，k8s挂载的不是物理机的env.json文件，而是ConfigMap对象的env.json键的值。ConfigMap对象是一个存储配置数据的API对象，它可以被Pod或其他对象引用 。你可以使用kubectl命令来创建或查看ConfigMap对象。例如：
    
    ```
    kubectl create configmap env-config --from-file=env.json
    kubectl get configmap env-config -o yaml
    ```
    
    这些命令会创建一个名为env-config的ConfigMap对象，它包含了一个键为env.json，值为文件内容的键值对。然后你可以在volume中引用这个ConfigMap对象，就像你的配置那样。
    

# 升级单个服务流程(node namespace label)

<aside> 💡 升级websafe命名空间下服务，迁移该服务从某node到某控制node下，并且使用宿主机的目录文件 - 不使用pv和pvc的挂载方式

</aside>

1. 打包build docker image
2. 保存服务docker镜像: docker save -o fizz_worker-2123.tar [repos-xa.inone.nsfocus.com/websafe-docker/fizz_worker:2123](http://repos-xa.inone.nsfocus.com/websafe-docker/fizz_worker:2123)
3. 查看当前集群中node: `kubectl get node -o wide --show-labels`
    1. 并找出控制节点 如含有: `run-package-node,worker`
    2. `k8s-worker1` 是控制节点名称
    3. 通过node名查看其上所部署的pod是否是目标服务: `kubectl get pod -A -o wide | grep k8s-worker1`
4. 查看当前服务运行所处node: `kubectl get pod -n websafe -o wide`
5. 查看服务node 择选器: `kubectl get deploy master-fizz-daemon -n websafe -o yaml | grep nodeSelector -9` 一个 kv
6. 给目标节点创建label
    1. `kubectl label nodes k8s-worker1 app-select=websafe-rcmlog`
    2. 查看是否成功 `kubectl get node -n websafe -o wide --show-labels | grep "k8s-worker1\\|rcmlog”`
7. 上传镜像到harbor
8. 修改deploy yaml文件(镜像版本、挂载目录、nodeSelector 其他(若有))，保存退出生效
    1. hostPath 挂载
        
        ```
          volumeMounts:
          - mountPath: /mnt/NPAI
            name: rcmlog-claim
        volumes:
        - hostPath:
            path: /opt/nsfocus/NPAI/data/sftp/bsa/rcm_log
            type: ""
          name: rcmlog-claim
        ```
        
    2. nodeSelector
        
        ```
        spec:
          nodeSelector:
            app-select: websafe-rcmlog
        ```
        
    3. 修改版本号为目标版本：2123（`image: [repos-xa.inone.nsfocus.com/websafe-docker/fizz_daemon:](<http://repos-xa.inone.nsfocus.com/websafe-docker/fizz_daemon:1979>)2123`)
        

# Docker Network

- 创建网络 `websafe-network` 使用 `IPv4Address` 进行连接
    
    ```makefile
    init_mysql:
    	docker run -p 3306:3306 \\
    	-e MYSQL_ROOT_PASSWORD=123456 \\
    	-e character-set-server=utf8mb4 \\
    	-e collation-server=utf8mb4_unicode_ci \\
    	--network websafe-network
    	-v /x/Code/websafe_online_svn/mysql/conf:/etc/mysql/conf.d \\
    	-v /x/Code/websafe_online_svn/mysql/logs:/logs \\
    	-v /x/Code/websafe_online_svn/mysql/db:/var/lib/mysql \\
    	-v /c/Windows/System32/drivers/etc/HOSTS:/etc/hosts \\
    	--name mysql56 mysql:5.6
    
    init_redis:
    	docker run -p 6379:6379 \\
    	--network websafe-network \\
    	--name redislatest redis:latest --requirepass 3b21d032a7fd8eb51fa7bd8a2e812b78b7b3a36f 
    
    join_network:
    	docker network connect websafe-network mysql56
    	docker network connect websafe-network daemon-xxx
    
    init_network:
    	docker network create websafe-network
    
    check_network:
    	docker network inspect websafe-network
    	docker network inspect websafe-network | findStr IPv4Address
    
    run:
    	docker run --name $(CONTAINER_NAME) -p 8888:80 \\
    	-e POD_OWN_NAME="master-xxxxxx" \\
    	--network websafe-network \\
    	-v /x/Code/websafe_online_svn/env.json:/etc/env.json \\
    	registry.nscloud:5000/kunkka/websafe/scancenter:latest
    ```
    

## Docker 限制内存/CPU占用

- 运行docker时如何限制其内存占用？
    
    [运行docker时可以使用**–memory**或**-m**选项来限制其内存占用1](https://docs.docker.com/config/containers/resource_constraints/)[2](https://www.baeldung.com/ops/docker-memory-limit)[3](https://phoenixnap.com/kb/docker-memory-and-cpu-limit)。例如：
    
    ```
    docker run -m 512m nginx
    ```
    
    [这个命令会限制nginx容器使用不超过512MB的内存。你还可以使用**–memory-reservation**选项来设置一个软限制，当主机内存不足时，docker会尽量保证容器的内存需求2](https://www.baeldung.com/ops/docker-memory-limit)。例如：
    
    ```
    docker run -m 512m --memory-reservation=256m nginx
    ```
    
    这个命令会保证nginx容器至少有256MB的内存，但最多不超过512MB。
    
- 如何限制cpu占用呢？
    
    [运行docker时可以使用**–cpus**或**–cpu-quota**选项来限制其CPU占用1](https://blog.csdn.net/yucaifu1989/article/details/106688554)[2](https://xobo.org/docker-limit-cpu-and-memory/)[3](https://stackoverflow.com/questions/42345235/how-to-specify-memory-cpu-limit-in-docker-compose-version-3)[4](https://docs.docker.com/config/containers/resource_constraints/)[5](https://www.baeldung.com/ops/docker-memory-limit)[6](https://phoenixnap.com/kb/docker-memory-and-cpu-limit)。例如：
    
    ```
    docker run --cpus=2 nginx
    ```
    
    [这个命令会限制nginx容器使用不超过2个CPU的资源。你还可以使用**–cpu-shares**选项来设置容器的CPU优先级4](https://docs.docker.com/config/containers/resource_constraints/)[5](https://www.baeldung.com/ops/docker-memory-limit)。例如：
    
    ```
    docker run --cpus=2 --cpu-shares=2000 nginx
    ```
    
    这个命令会给nginx容器分配更高的CPU优先级，相对于默认值1024。
    

# Docker 在 k8s

- 使用k8s 加载 docker镜像时，dockerfile中的CMD为什么没有执行？
    
    根据搜索结果[1](https://blog.csdn.net/u013641234/article/details/108237295)[2](https://kubernetes.io/zh/docs/tasks/inject-data-application/define-command-argument-container/)，k8s中的command和args会覆盖dockerfile中的entrypoint和cmd，所以如果您在k8s配置文件中设置了command或args，那么dockerfile中的cmd可能就不会执行。请检查您的k8s配置文件是否有这样的设置。
    
    [另外，dockerfile中的cmd也可能被容器启动时附加的指令忽略3](https://juejin.cn/post/6987957373595811871)，请检查您是否在启动容器时指定了其他命令。
    

## Docker CMD 和 K8s Command

- 如果在k8s配置中没有指定command，那么容器启动时会执行dockerfile中指定的CMD命令作为默认命令。如果dockerfile中也没有指定CMD命令，则容器启动时不会执行任何命令，只是启动一个空的容器。因此，如果想要在k8s中保留dockerfile中指定的CMD命令，可以不指定command，或者在指定command时将CMD命令包含在内。
- 启动命令应该写在k8s配置中的command中，因为这样可以灵活地控制容器启动时执行的命令，而不受dockerfile中的CMD命令的限制。此外，将启动命令写在k8s配置中也可以方便地进行配置管理和版本控制，便于维护和更新。当然，如果dockerfile中的CMD命令已经满足需求，也可以直接使用默认命令，不需要在k8s配置中指定command。