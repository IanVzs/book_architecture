title: Paddle
date: 2022-06-08 18:58:56
modified: 2022-06-08 18:58:56
category: [note, 机器学习]
tags: [Paddle]
slug: 
---

![天坑](https://th.bing.com/th/id/R.51a92409a6ab153b1ef0a45bc252c001?rik=8zti23A8ZlF6TA&riu=http%3a%2f%2f5b0988e595225.cdn.sohucs.com%2fimages%2f20180125%2f3195f903a92843f8b39058abb2982c9e.jpeg&ehk=7KSd71aeS7%2fSjkkVHUVubARN75%2f7e5CWFhARxbWe0kY%3d&risl=&pid=ImgRaw&r=0&sres=1&sresct=1)

# Paddle的坑
## 资源占用
命令示例(yml中修改了`train,test`样本地址,使用`--gpus`这里只用了一个GPU,可方便修改为多卡`0,1,2,3`)
```bash
python -m paddle.distributed.launch --gpus '1'  tools/train.py -c configs/rec/PP-OCRv3/en_PP-OCRv3_rec.yml -o Global.pretrained_model=./pretrain_models/en_PP-OCRv3_rec_train/best_accuracy.pdparams
```
`en_PP-OCRv3_rec`默认性能配置在, 单卡V100上:
+-------------------------------+----------------------+----------------------+
|   1  Tesla V100-SXM2...  On   | 00000000:00:09.0 Off |                    0 |
| N/A   53C    P0   223W / 300W |  23065MiB / 32510MiB |    100%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+

## Paddle 多卡训练
You may need to install 'nccl2' from NVIDIA official website

Traceback: 这种问题可以参看[Github Issues](https://github.com/PaddlePaddle/PaddleOCR/issues/3327)
## 写在坑前头
经测试，下面预训练模型下载地址和检测训练效果的脚本之所以报错是因为`PaddleOCR`项目主页的`readme`中链接的子`readme`是`develop`分支的。且这个分支是落后于当前`release/2.5`的，所以出现了以下不匹配的情况.
切换了分支之后, 匹配度还可以接受.

## PaddleOCR 预训练模型

- 百度写文档的积极性是真的低，看来这东西用的人是真的少...

这是官方说明文档:
```
cd PaddleOCR/
# 下载MobileNetV3的预训练模型
wget -P ./pretrain_models/ https://paddle-imagenet-models-name.bj.bcebos.com/MobileNetV3_large_x0_5_pretrained.tar
# 或，下载ResNet18_vd的预训练模型
wget -P ./pretrain_models/ https://paddle-imagenet-models-name.bj.bcebos.com/ResNet18_vd_pretrained.tar
# 或，下载ResNet50_vd的预训练模型
wget -P ./pretrain_models/ https://paddle-imagenet-models-name.bj.bcebos.com/ResNet50_vd_ssld_pretrained.tar

# 解压预训练模型文件，以MobileNetV3为例
tar -xf ./pretrain_models/MobileNetV3_large_x0_5_pretrained.tar ./pretrain_models/

# 注：正确解压backbone预训练权重文件后，文件夹下包含众多以网络层命名的权重文件，格式如下：
./pretrain_models/MobileNetV3_large_x0_5_pretrained/
  └─ conv_last_bn_mean
  └─ conv_last_bn_offset
  └─ conv_last_bn_scale
  └─ conv_last_bn_variance
  └─ ......
```
### 但是
- Paddle 在1.8版本后已经不用这种格式的预训练模型了！
- 2022-06-07 现在已经更新到`2.3.0` 所以下载下来压根不能使用
```
wget -P ./pretrain_models/ https://paddle-imagenet-models-name.bj.bcebos.com/dygraph/ResNet18_vd_pretrained.pdparams
```
- 增加`dygraph`
- 后缀修改为`pdparams`

## 使用训练结果检测单张图片
应使用:
```bash
python tools/infer_det.py --config=configs/det/det_res18_db_v2.0.yml -o Global.infer_img="./train_data/icdar2015/ch4_test_images/img_4.jpg" Global.checkpoints="./output/ch_db_res18/latest.pdparams" Global.use_gpu=false
```
而非官网所示的:
```bash
python3 tools/infer_det.py -c configs/det/det_mv3_db_v1.1.yml -o Global.infer_img="./doc/imgs_en/img_10.jpg" Global.checkpoints="./output/det_db/best_accuracy"
```
否则会报错: 
```bash
Traceback (most recent call last):
  File "... /PaddleOCR/tools/infer_det.py", line 133, in <module>
    config, device, logger, vdl_writer = program.preprocess()
  File "... /PaddleOCR/tools/program.py", line 535, in preprocess
    FLAGS = ArgsParser().parse_args()
  File "... /PaddleOCR/tools/program.py", line 57, in parse_args
    assert args.config is not None, \
AssertionError: Please specify --config=configure_file_path.
```

## 多卡和断点续传
断点可能怕是不行了。。。

多卡使用:
```bash
python -m paddle.distributed.launch --gpus '1,2' tools/train.py -c configs/det/det_res18_db_v2.0.yml -o Global.use_gpu=true Global.checkpoints="./output/ch_db_res18/latest.pdparams"  | tee train_det.log
```
会出现:
```bash
[2022/06/08 18:36:48] ppocr INFO:         num_workers : 4
[2022/06/08 18:36:48] ppocr INFO:         shuffle : True
[2022/06/08 18:36:48] ppocr INFO: profiler_options : None
[2022/06/08 18:36:48] ppocr INFO: train with paddle 2.3.0 and device Place(gpu:1)
server not ready, wait 3 sec to retry...
not ready endpoints:['127.0.0.1:36939']
W0608 18:36:51.403939 745832 dynamic_loader.cc:276] You may need to install 'nccl2' from NVIDIA official website: https://developer.nvidia.com/nccl/nccl-downloadbefore install PaddlePaddle.
Traceback (most recent call last):
  File "tools/train.py", line 191, in <module>
    main(config, device, logger, vdl_writer)
  File "tools/train.py", line 47, in main
    dist.init_parallel_env()
  File "/data/anaconda3/lib/python3.8/site-packages/paddle/distributed/parallel.py", line 315, in init_parallel_env
    parallel_helper._init_parallel_ctx()
  File "/data/anaconda3/lib/python3.8/site-packages/paddle/fluid/dygraph/parallel_helper.py", line 42, in _init_parallel_ctx
    __parallel_ctx__clz__.init()
RuntimeError: (PreconditionNotMet) The third-party dynamic library (libnccl.so) that Paddle depends on is not configured correctly. (error code is libnccl.so: cannot open shared object file: No such file or directory)
  Suggestions:
  1. Check if the third-party dynamic library (e.g. CUDA, CUDNN) is installed correctly and its version is matched with paddlepaddle you installed.
  2. Configure third-party dynamic library environment variables as follows:
  - Linux: set LD_LIBRARY_PATH by `export LD_LIBRARY_PATH=...`
  - Windows: set PATH by `set PATH=XXX; (at /paddle/paddle/phi/backends/dynload/dynamic_loader.cc:303)
```
