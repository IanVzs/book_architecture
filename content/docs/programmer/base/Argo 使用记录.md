Github: https://github.com/argoproj
## 一、简介
目前Argo项目中有如下几个子项目：
- [argoproj](https://github.com/argoproj/argopro) `Common project repo for all Argo Projects`
- [gitops-engine](https://github.com/argoproj/gitops-engine) `Public Democratizing GitOps`

- [argo-workflows](https://github.com/argoproj/argo-workflows) `Workflow engine for Kubernetes`
- [argo-cd](https://github.com/argoproj/argo-cd) `Declarative continuous deployment for Kubernetes.`
- [argo-events](https://github.com/argoproj/argo-events) `Event-driven automation framework`
- [argo-rollouts](https://github.com/argoproj/argo-rollouts) `Progressive Delivery for Kubernetes`

`cd`和`rollouts`一个是持续交付工具，一个是渐进式发布工具，与原子能力关系不大。
`workflows`和`events`一个是基于容器的任务编排工具，一个是事件驱动框架。都与本次原子能力相关。

这样，就可以设计出一个由新建扫描任务事件触发，实例化经过编排可实现扫描全流程的方案。

**流程如下：![[book_architecture/content/docs/programmer/base/argo_events_workfows.png]]**

### sensor作用
- 使事件转发和处理松耦合
- Trigger事件的参数化，比如根据事件内容动态生成
## 二、Argo Workflow编排
<details><summary>点击展开Yaml</summary>
<pre>
<code yaml>
apiVersion: argoproj.io/v1alpha1
kind: Workflow
metadata:
  generateName: coinflip-recursive-
spec:
  entrypoint: coinflip
  templates:
  - name: coinflip
    steps:
    - - name: flip-coin
        template: flip-coin
    - - name: heads
        template: heads
        when: "{{steps.flip-coin.outputs.result}} == heads"
      - name: tails
        template: coinflip
        when: "{{steps.flip-coin.outputs.result}} == tails"

  - name: flip-coin
    script:
      image: python:alpine3.6
      command: [python]
      source: |
        import random
        result = "heads" if random.randint(0,1) == 0 else "tails"
        print(result)

  - name: heads
    container:
      image: alpine:3.6
      command: [sh, -c]
      args: ["echo \"it was heads\""]
</code>
</pre></details>

## 三、Argo Events使用
1. 定义一个webhook(名称: webhook_example)路径/webhook, 端口12000, 接收 POST 方法.
```yaml
apiVersion: argoproj.io/v1alpha1
kind: EventSource
metadata:
  name: webhook
spec:
  service:
    ports:
      - port: 12000
        targetPort: 12000
  webhook:
    webhook_example:
      port: "12000"
      endpoint: /webhook
      method: POST
```
2. 定义`Sensor` 指定行为
<details><summary>点击展开yaml文件</summary>
<pre>
<code yaml>
apiVersion: argoproj.io/vlalpha1
kind: Sensor
metadata:
  name: webhook
spec:
  template:
    serviceAccountName: argo-events-sa
  dependencies # 订阅的事件
    - name: test-dep
      eventSourceName: webhook
      eventName: webhook_example
  triggers:
    - template
      name:webhook-workflow-triaae
      k8s: # 定义触发器为创建一个workflow资源
        group: argoproj.io
        version: vlalpha1
        resource: workflows
        operation: create
        source:
          resource:
            apiVersion: argoproj.io/vlalpha1
            kind: Workflow
            metadata:
              generateName: webhook-
            spec:
              entrypoint: whalesay
              arguments:
                parameters:
                - name: message
                  value: hello world
              templates:
              - name: whalesay
                serviceAccountName: argo-events-sa
                inputs:
                  parameters: # 参数替换
                  -name: message
                container:
                  image: docker/whalesay:latest
                  command:[cowsay]
                  args :["{{input.parameters.message}}"]
        parameters:
          - src:
            dependencyName: test-dep
	      dest: spec.arquments.parameters.0.value
</code></pre></details>

Yaml说明: 
		i. 定义了订阅的EventSource以及具体的Webhook(一个EventSource可以定义多个Webhook,因此指定俩参数)
		ii. Trigger中定义了对应Action 创建一个werkflow, workflow的spec在respirce中配置
		iii. parameters定义了workfolw的参数,从event中获取,如上将整个event都作为input(只获取body部分可通过: dataKey: body.message)
		iv: 此时 `curl -X POST -d '{"message": "Hello"}' 127.0.0.1:12000/webhook`,可见argo workflow中创建了一个实例. 如传入整个请求,获得的数据可能经由base64编码的,需要解码后使用`{"context": "", "data": "包含header和body"}`
		v: 其他用法查看: [这里](https://blog.51cto.com/u_15103028/2647114)
### 需验证的问题
1. workflow并行处理多个不同参数的相同任务效率需要验证

## 四、部署
### 1. 运维命令
```bash
argo submit hello-world.yaml    # submit a workflow spec to Kubernetes
argo list                       # list current workflows
argo get hello-world-xxx        # get info about a specific workflow
argo logs hello-world-xxx       # print the logs from a workflow
argo delete hello-world-xxx     # delete workflow
```
### 2. 安装和启动

```bash
kubectl create namespace argo
kubectl apply -f https://raw.githubusercontent.com/argoproj/argo-workflows/master/manifests/quick-start-postgres.yaml # 最全-精简安装看别的
# 查看运行状态
kubectl get pods -n argo
kubectl get svc -n argo
# 将svc改为nodeport方便访问Web UI
kubectl edit svc -n argo argo-workflow-argo-workflows-server # 或者argo-server 名字会变但是差不多这意思 进去手动将ClusterIP改为NodePort

# 查看argo server pod在哪个node上运行 端口映射到了node哪个端口
kubectl get pods -n argo -o wide
# 查看该node IP
kubectl get node -o wide
# http//nodeip:nodePort访问

# 提交任务
argo submit https://github.com/argoproj/argo-workflows/blob/master/examples/coinflip.yaml --watch -n argo # 将yaml下载下载执行为佳
```
#### 权限问题
```bash
User "system:serviceaccount:argo:default" cannot patch resource "pods" in API group "" in the namespace "argo": RBAC: role.rbac.authorization.k8s.io "argo-workflow" not found
```
```bash
Confusing, possibly erroneous RBAC warnings ("Failed to get pod")
```
可见: [argo-workflows Issues](https://github.com/argoproj/argo-workflows/issues/2228)
<details><summary>点击展开-kubectl apply -f auth.yaml可解决</summary>
<pre>
<code yaml>
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: argo-invocation
  namespace: argo
rules:
- apiGroups:
  - "argoproj.io"
  resources:
  - "workflows"
  verbs:
  - get
  - list
  - watch
  - create
  - update
  - patch
  - delete
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: default-default-invocation
  namespace: argo
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: argo-invocation
subjects:
- kind: ServiceAccount
  name: default
  namespace: default # give workflows (as argo:default) permissions to run things # see https://github.com/argoproj/argo/blob/master/docs/workflow-rbac.md
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: argo-workflow
  namespace: argo
rules: # pod get/watch is used to identify the container IDs of the current pod # pod patch is used to annotate the step's outputs back to controller (e.g. artifact location)
- apiGroups:
  - ""
  resources:
  - pods
  verbs:
  - get
  - watch
  - patch # logs get/watch are used to get the pods logs for script outputs, and for log archival
- apiGroups:
  - ""
  resources:
  - pods/log
  verbs:
  - get
  - watch
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: argo-default-workflow
  namespace: argo
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: argo-workflow
subjects:
- kind: ServiceAccount
  name: default
  namespace: argo
</code>
</pre></details>

## ETCD
>因为k8s状态都在etcd集群中，所以需要关注一下大量workflow会不会占用过多的容量资源
```sh
ETCDCTL_API=3 etcdctl --cacert /etc/kubernetes/pki/etcd/ca.crt --cert /etc/kubernetes/pki/etcd/healthcheck-client.crt --key /etc/kubernetes/pki/etcd/healthcheck-client.key  --write-out=table endpoint status
+----------------+------------------+---------+---------+-----------+------------+-----------+------------+--------------------+--------+
|    ENDPOINT    |        ID        | VERSION | DB SIZE | IS LEADER | IS LEARNER | RAFT TERM | RAFT INDEX | RAFT APPLIED INDEX | ERRORS |
+----------------+------------------+---------+---------+-----------+------------+-----------+------------+--------------------+--------+
| 127.0.0.1:2379 | 871f72e4ab5a28e8 |   3.5.0 |  104 MB |      true |      false |        35 |  348058564 |          348058564 |        |
+----------------+------------------+---------+---------+-----------+------------+-----------+------------+--------------------+--------+
```
根据提供的信息，可以看到以下解释：
- ENDPOINT: etcd集群的地址为127.0.0.1:2379。
- ID: etcd集群的唯一标识为871f72e4ab5a28e8。
- VERSION: etcd的版本为3.5.0。
- DB SIZE: etcd数据库当前占用的空间大小为104 MB。
- IS LEADER: 当前节点是否为etcd集群的Leader节点，这里显示为true。
- IS LEARNER: 当前节点是否为etcd集群的Learner节点，这里显示为false。
- RAFT TERM: 当前etcd集群的Raft Term为35。
- RAFT INDEX: 当前etcd集群的Raft Index为348058564。
- RAFT APPLIED INDEX: 当前etcd集群已应用的Raft Index为348058564。
- ERRORS: 没有显示任何错误信息。
总体上，这些信息展示了etcd集群的状态，包括节点角色、版本、数据库大小等。

## 大量Workflows优化建议
>You have at least 230 completed workflows. Reducing the total number of workflows will reduce your costs.
Learn more at https://argoproj.github.io/argo-workflows/cost-optimisation/


## 创建时缺少安全上下文问题
>This workflow does not have security context set. You can run your workflow pods more securely by setting it.
Learn more at https://argoproj.github.io/argo-workflows/workflow-pod-security-context/

## 修改执行器
<details><summary>点击展开-Argo server读取的configmap</summary>
<pre>
<code yaml>
apiVersion: v1
data:
  artifactRepository: |
    s3:
      bucket: argo
      # modify 根据实际修改
      endpoint: x.xxx:9000
      insecure: true
      accessKeySecret:
        name: my-minio-cred
        key: accesskey
      secretKeySecret:
        name: my-minio-cred
        key: secretkey
  containerRuntimeExecutor: emissary // docker这里切换Executor 有的特性需要emissary才能执行
  executor: |
    resources:
      requests:
        cpu: 10m
        memory: 64Mi
  links: |
    - name: Workflow Link
      scope: workflow
      url: http://logging-facility?namespace=${metadata.namespace}&workflowName=${metadata.name}&startedAt=${status.startedAt}&finishedAt=${status.finishedAt}
    - name: Pod Link
      scope: pod
      url: http://logging-facility?namespace=${metadata.namespace}&podName=${metadata.name}&startedAt=${status.startedAt}&finishedAt=${status.finishedAt}
    - name: Pod Logs Link
      scope: pod-logs
      url: http://logging-facility?namespace=${metadata.namespace}&podName=${metadata.name}&startedAt=${status.startedAt}&finishedAt=${status.finishedAt}
    - name: Event Source Logs Link
      scope: event-source-logs
      url: http://logging-facility?namespace=${metadata.namespace}&podName=${metadata.name}&startedAt=${status.startedAt}&finishedAt=${status.finishedAt}
    - name: Sensor Logs Link
      scope: sensor-logs
      url: http://logging-facility?namespace=${metadata.namespace}&podName=${metadata.name}&startedAt=${status.startedAt}&finishedAt=${status.finishedAt}
  metricsConfig: |
    enabled: true
    path: /metrics
    port: 9090
  namespaceParallelism: "200" // 单个nm下最大工作流并发数
  persistence: |
    connectionPool:
      maxIdleConns: 100
      maxOpenConns: 0
      connMaxLifetime: 0s
    nodeStatusOffLoad: true
    archive: true
    archiveTTL: 7d
    # modify 根据实际修改，需要为argo创建单独的数据库，并修改下方的host. port. database 三个配置
    postgresql:
      host: xx-base-postgresql.ez-plus
      port: 5432
      database: postgres
      tableName: argo_workflows
      userNameSecret:
        name: argo-postgres-config
        key: username
      passwordSecret:
        name: argo-postgres-config
        key: password
  retentionPolicy: |
    completed: 10
    failed: 3
    errored: 3
kind: ConfigMap
metadata:
  annotations:
    meta.helm.sh/release-name: argo
    meta.helm.sh/release-namespace: argo
  labels:
    app.kubernetes.io/managed-by: Helm
  name: workflow-controller-configmap
  namespace: argo
</code>
</pre></details>
