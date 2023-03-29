---
title: k8s
date: 2023-03-27 10:58:56
category: [note, k8s, docker]
tags: [Linux]
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
