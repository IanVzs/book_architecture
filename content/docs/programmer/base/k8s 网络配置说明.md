---
title: k8s网络配置说明
date: 2023-09-07 20:58:56
category:
  - note
  - k8s
  - docker
tags:
  - Linux
slug:
---

# k8s 网络介绍

- Ingress 定义路由，本质只是配置文件，需要Ingress Controller读取执行
- 当集群中存在多个Controller时，就需要使用Ingress Class来区分对应的是哪个
- 