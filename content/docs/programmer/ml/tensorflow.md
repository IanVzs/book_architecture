---
title: Tensorflow
date: 2022-03-30 17:23:23
categories: [tip, 版本兼容]
tags:
---

![tensorflow](https://www.gstatic.cn/devrel-devsite/prod/vc705ce9bd51279e80f03a51aec7c6eb1f05e56e75c958618655fc719098c9888/tensorflow/images/lockup.svg "tensorflow")
## v2兼容v1 API
```py
import tensorflow.compat.v1 as tf
tf.disable_v2_behavior()
```
