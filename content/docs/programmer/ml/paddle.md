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

## LSTM Model
```python
import os
import sys
import jieba
import codecs
import chardet
import shutil
import time
from tqdm import tqdm, trange
from bs4 import BeautifulSoup

import paddle
import paddlenlp
chardet.__dict__

import numpy as np
from functools import partial
import paddle.nn as nn
import paddle.nn.functional as F
import paddlenlp as ppnlp
from paddlenlp.data import Pad, Stack, Tuple
print(paddle.__version__, paddlenlp.__version__)
# from paddlenlp.datasets import MapDatasetWrapper
# 加载文件列表
import pandas as pd
columns = ['id', 'flag', 'filename', 'url']
tempdf = pd.read_csv('MaliciousWebpage/file_list.txt', sep=',',skiprows=0, header=None, names=columns, skipfooter=0)
tempdf[:5]


# p为钓鱼页面，d为被黑页面，n为正常页面
tempdf['flag'].unique()
tempdf['flag'].value_counts()
# 查看正常页面对应的filename
df1=tempdf[tempdf['flag']=='n']
df1.head()


# 选择一个正常页面进行html内容解析
html = BeautifulSoup(open('MaliciousWebpage/file1/'+'66178272dee70b26f1400bb5c2aea1ab', encoding="utf-8"),'html.parser', from_encoding='utf-8')
# 获取最后20组非标签字符串，会自动去掉空白字符串，返回的是一个list
list(html.stripped_strings)[-20:]

# 由于在PaddleNLP进行文本分类时，我们需要构造的输入内容是一串连续的文字，因此这里要用到list和string的转化
# 将list转化为string
print(''.join(list(html.stripped_strings)[-20:]))


n_page = tempdf[tempdf['flag']=='n']

# 对正常页面进行随机采样
n_page = n_page.sample(n=500)

# 提取全部被黑页面样本
d_page = tempdf[tempdf['flag']=='d']

# 合并样本
train_page = pd.concat([n_page,d_page],axis=0)

# 做一个乱序
train_page = train_page.sample(frac = 1) 

# 查看效果，确认数据集的样本准备完成
train_page.head(10)


for filename in tqdm(train_page['filename']):
    # 这里要先做个判断，有的file_list里面的文件不存在
    if os.path.exists('MaliciousWebpage/file1/'+filename):
        # 读取文件，获取字符集
        content = codecs.open('MaliciousWebpage/file1/'+filename,'rb').read()
        source_encoding = chardet.detect(content)['encoding']
        # 个别文件的source_encoding是None，这里要先进行筛选
        if source_encoding is None:
            pass
        # 只对字符集是gb2312格式的文件尝试转码
        elif source_encoding == 'gb2312':
            # 转码如果失败，就跳过该文件
            try:
                content = content.decode(source_encoding).encode('utf-8')
                codecs.open('TrainWebpage/file1/'+filename,'wb').write(content)
            except UnicodeDecodeError:
                print(filename + "读取失败")
                pass
        # 字符集是utf-8格式的文件直接保存
        elif source_encoding == 'utf-8':
            codecs.open('TrainWebpage/file1/'+filename,'wb').write(content)
        else:
            pass
    else:
        pass

for i, filename in enumerate(tqdm(train_page['filename'])):
    # 这里要先做个判断，有的file_list里面的文件不存在
    if os.path.exists('TrainWebpage/file1/'+filename):
        # 读取文件，解析HTML页面
        html = BeautifulSoup(open('TrainWebpage/file1/'+filename, encoding="utf-8"),'html.parser', from_encoding='utf-8')
        text = ''.join(list(html.stripped_strings)[-20:])
        # 去掉多余的换行符（部分数据最后解析结果为）
        text = text.replace("\n", "")
        text = text.replace(" ", ",")
        # real_label = train_page['flag'][train_page['filename']==filename].values[0]
        if i % 5 == 0:
            if train_page['flag'][train_page['filename']==filename].values[0] == 'n':
                with open("webtest.txt","a+", encoding="utf-8") as f:
                    f.write(text[-100:] + '\t' + '0' + '\n')
            elif train_page['flag'][train_page['filename']==filename].values[0] == 'd':
                with open("webtest.txt","a+", encoding="utf-8") as f:
                    f.write(text[-100:] + '\t' + '1' + '\n')
        elif i % 5 == 1:
            if train_page['flag'][train_page['filename']==filename].values[0] == 'n':
                with open("webdev.txt","a+", encoding="utf-8") as f:
                    f.write(text[-100:] + '\t' + '0' + '\n')
            elif train_page['flag'][train_page['filename']==filename].values[0] == 'd':
                with open("webdev.txt","a+", encoding="utf-8") as f:
                    f.write(text[-100:] + '\t' + '1' + '\n')
        else:
            if train_page['flag'][train_page['filename']==filename].values[0] == 'n':
                with open("webtrain.txt","a+", encoding="utf-8") as f:
                    f.write(text[-100:] + '\t' + '0' + '\n')
            elif train_page['flag'][train_page['filename']==filename].values[0] == 'd':
                with open("webtrain.txt","a+", encoding="utf-8") as f:
                    f.write(text[-100:] + '\t' + '1' + '\n')
    else:
        pass

class MyDataset(paddle.io.Dataset):
    """
    步骤一：继承 paddle.io.Dataset 类
    """
    def __init__(self, data_path="", data_list=[]):
        """
        步骤二：实现 __init__ 函数，初始化数据集，将样本和标签映射到列表中
        """
        super().__init__()
        if data_list:
            self.data_list = data_list
        else:
            self.data_list = []
            with open(data_path, encoding='utf-8') as f:
                for line in f:
                    self.data_list.append(line.strip().split('\t'))

    def __getitem__(self, index):
        """
        步骤三：实现 __getitem__ 函数，定义指定 index 时如何获取数据，并返回单条数据（样本数据、对应的标签）
        """
        # 根据索引，从列表中取出一个图像
        try:
            data = self.data_list[index]
            if len(data) == 2:
                content, label = data
            elif len(data) >= 2:
                label = data[-1]
                content = ''.join(data[0: -1])
                print(f"fuck you: {data} index: {index}")
        except Exception as err:
            print(f"阿西吧: {self.data_list[index]}， index: {index}")
        label = int(label)
        return [content, label]

    def __len__(self):
        """
        步骤四：实现 __len__ 函数，返回数据集的样本总数
        """
        return len(self.data_list)

    def get_labels(self):
        return [0, 1]


train_ds, dev_ds, test_ds = MyDataset('webtrain.txt'), MyDataset('webdev.txt'), MyDataset('webtest.txt')
label_list = train_ds.get_labels()
print(label_list)
for i in range(10):
    print (train_ds[i])


import jieba

dict_path = 'webdict.txt'

#创建数据字典，存放位置：webdict.txt。在生成之前先清空webdict.txt
#在生成all_data.txt之前，首先将其清空
with open(dict_path, 'w', encoding="utf-8") as f:
    f.seek(0)
    f.truncate() 


dict_set = set()
train_data = open('webtrain.txt', encoding="utf-8")
for data in train_data:
    seg = jieba.lcut(data[:-3])
    for datas in seg:
        if datas != " ":
            dict_set.add(datas)

dicts = open(dict_path,'w', encoding="utf-8")
dicts.write('[PAD]\n')
dicts.write('[UNK]\n')
for data in dict_set:
    dicts.write(data + '\n')
dicts.close()


# # 下载词汇表文件word_dict.txt，用于构造词-id映射关系。
# !wget https://paddlenlp.bj.bcebos.com/data/senta_word_dict.txt

def load_vocab(vocab_file):
    """Loads a vocabulary file into a dictionary."""
    vocab = {}
    with open(vocab_file, "r", encoding="utf-8") as reader:
        tokens = reader.readlines()
    for index, token in enumerate(tokens):
        token = token.rstrip("\n").split("\t")[0]
        vocab[token] = index
    return vocab

# 加载词表
# vocab = load_vocab('data/webdict.txt')
vocab = load_vocab('./webdict.txt')

for k, v in vocab.items():
    print(k, v)
    break

def convert_example(example, vocab, unk_token_id=1, is_test=False):
    tokenizer = jieba
    """
    Builds model inputs from a sequence for sequence classification tasks.
    It use `jieba.cut` to tokenize text.
    Args:
        example(obj:`list[str]`): List of input data, containing text and label if it have label.
        vocab(obj:`dict`): The vocabulary.
        unk_token_id(obj:`int`, defaults to 1): The unknown token id.
        is_test(obj:`False`, defaults to `False`): Whether the example contains label or not.
    Returns:
        input_ids(obj:`list[int]`): The list of token ids.s
        valid_length(obj:`int`): The input sequence valid length.
        label(obj:`numpy.array`, data type of int64, optional): The input label if not is_test.
    """

    input_ids = []
    # print("example 是: ", example)
    if len(example) != 2:
        print(f"fuck you!: {example}")
    for token in tokenizer.cut(example[0]):
        token_id = vocab.get(token, unk_token_id)
        input_ids.append(token_id)
    valid_length = np.array([len(input_ids)])
    input_ids = np.array(input_ids, dtype="int32")
    if not is_test:
        label = np.array(example[-1], dtype="int64")
        return input_ids, valid_length, label
    else:
        return input_ids, valid_length

# python中的偏函数partial，把一个函数的某些参数固定住（也就是设置默认值），返回一个新的函数，调用这个新函数会更简单。
trans_function = partial(
    convert_example,
    vocab=vocab,
    unk_token_id=vocab.get('[UNK]', 1),
    is_test=False)


# 版本不匹配的兼容修改方式
from paddlenlp.datasets import MapDataset
train_ds_new = MapDataset(train_ds)
dev_ds_new = MapDataset(dev_ds)
test_ds_new = MapDataset(test_ds)

# train_ds_new.map(trans_function, lazy=True)


def create_dataloader(dataset,
                      trans_function=None,
                      mode='train',
                      batch_size=1,
                      pad_token_id=0,
                      batchify_fn=None):
    if trans_function:
        dataset = dataset.map(trans_function, lazy=True)

    # return_list 数据是否以list形式返回
    # collate_fn  指定如何将样本列表组合为mini-batch数据。传给它参数需要是一个callable对象，需要实现对组建的batch的处理逻辑，并返回每个batch的数据。在这里传入的是`prepare_input`函数，对产生的数据进行pad操作，并返回实际长度等。
    dataloader = paddle.io.DataLoader(
        dataset,
        return_list=True,
        batch_size=batch_size,
        collate_fn=batchify_fn)
        
    return dataloader


# 将读入的数据batch化处理，便于模型batch化运算。
# batch中的每个句子将会padding到这个batch中的文本最大长度batch_max_seq_len。
# 当文本长度大于batch_max_seq时，将会截断到batch_max_seq_len；当文本长度小于batch_max_seq时，将会padding补齐到batch_max_seq_len.
batchify_fn = lambda samples, fn=Tuple(
    Pad(axis=0, pad_val=vocab['[PAD]']),  # input_ids
    Stack(dtype="int64"),  # seq len
    Stack(dtype="int64")  # label
): [data for data in fn(samples)]


train_loader = create_dataloader(
    train_ds_new,
    trans_function=trans_function,
    batch_size=32,
    mode='train',
    batchify_fn=batchify_fn)
dev_loader = create_dataloader(
    dev_ds_new,
    trans_function=trans_function,
    batch_size=32,
    mode='validation',
    batchify_fn=batchify_fn)
test_loader = create_dataloader(
    test_ds_new,
    trans_function=trans_function,
    batch_size=32,
    mode='test',
    batchify_fn=batchify_fn)

class LSTMModel(nn.Layer):
    def __init__(self,
                 vocab_size,
                 num_classes,
                 emb_dim=64,
                 padding_idx=0,
                 lstm_hidden_size=96,
                 direction='forward',
                 lstm_layers=2,
                 dropout_rate=0,
                 pooling_type=None,
                 fc_hidden_size=48):
        super().__init__()

        # 首先将输入word id 查表后映射成 word embedding
        self.embedder = nn.Embedding(
            num_embeddings=vocab_size,
            embedding_dim=emb_dim,
            padding_idx=padding_idx)

        # 将word embedding经过LSTMEncoder变换到文本语义表征空间中
        self.lstm_encoder = ppnlp.seq2vec.LSTMEncoder(
            emb_dim,
            lstm_hidden_size,
            num_layers=lstm_layers,
            direction=direction,
            dropout=dropout_rate,
            pooling_type=pooling_type)

        # LSTMEncoder.get_output_dim()方法可以获取经过encoder之后的文本表示hidden_size
        self.fc = nn.Linear(self.lstm_encoder.get_output_dim(), fc_hidden_size)

        # 最后的分类器
        self.output_layer = nn.Linear(fc_hidden_size, num_classes)

    def forward(self, text, seq_len):
        # text shape: (batch_size, num_tokens)
        # print('input :', text.shape)
        
        # Shape: (batch_size, num_tokens, embedding_dim)
        embedded_text = self.embedder(text)
        # print('after word-embeding:', embedded_text.shape)

        # Shape: (batch_size, num_tokens, num_directions*lstm_hidden_size)
        # num_directions = 2 if direction is 'bidirectional' else 1
        text_repr = self.lstm_encoder(embedded_text, sequence_length=seq_len)
        # print('after lstm:', text_repr.shape)


        # Shape: (batch_size, fc_hidden_size)
        fc_out = paddle.tanh(self.fc(text_repr))
        # print('after Linear classifier:', fc_out.shape)

        # Shape: (batch_size, num_classes)
        logits = self.output_layer(fc_out)
        # print('output:', logits.shape)
        
        # probs 分类概率值
        probs = F.softmax(logits, axis=-1)
        # print('output probability:', probs.shape)
        return probs

model= LSTMModel(
        len(vocab),
        len(label_list),
        direction='bidirectional',
        padding_idx=vocab['[PAD]'])
model = paddle.Model(model)
model


optimizer = paddle.optimizer.Adam(
        parameters=model.parameters(), learning_rate=1e-4)

loss = paddle.nn.CrossEntropyLoss()
metric = paddle.metric.Accuracy()

model.prepare(optimizer, loss, metric)


# 设置visualdl路径
log_dir = './visualdl'
callback = paddle.callbacks.VisualDL(log_dir=log_dir)

model.fit(train_loader, dev_loader, epochs=100, save_dir='./checkpoints', save_freq=5, callbacks=callback)

results = model.evaluate(dev_loader)
print("Finally test acc: %.5f" % results['acc'])
print(results)

import random
label_map = {0: '正常页面', 1: '被黑页面'}
results = model.predict(test_loader, batch_size=128)[0]
predictions = []

for batch_probs in results:
    # 映射分类label
    idx = np.argmax(batch_probs, axis=-1)
    idx = idx.tolist()
    labels = [label_map[i] for i in idx]
    predictions.extend(labels)

# 看看预测数据前5个样例分类结果
for idx, data in enumerate(test_ds.data_list[:10]):
   print('Data: {} \t Value: {} \t Label: {}'.format(data[0], data[-1], predictions[idx]))
```

### 可视化
```bash
python -m pip install visualdl -i https://mirror.baidu.com/pypi/simple
visualdl.exe --logdir .
```
