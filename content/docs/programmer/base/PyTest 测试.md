[TOC]
# 命令
## Django 整合进 pytest测试
```bash
pip install pytest-django
pytest -s -vv .\tests\test_step2.py  --rootdir X:\Code\workflows\ --ds project.settings
```
- rootdir 指定项目根目录
- ds 指向django `setting.py` 文件

## 一、为什么需要pytest

`helps you write better programs`

- 提高阅读理解代码效率
- 提高debug效率
- 提高开发效率
- 保证交付代码质量

### 简单例子

> 入门例子:
1. 了解使用test文件命名格式: `test_`前缀
2. 了解断言`assert`
3. 了解测试输出

```python
# content of test_sample.py
def inc(x):
    return x + 1

def test_answer():
    assert inc(3) == 5
```

> 输出
```bash
$ pytest
=========================== test session starts ============================
platform linux -- Python 3.x.y, pytest-7.x.y, pluggy-1.x.y
rootdir: /home/sweet/project
collected 1 item
test_sample.py F                                                     [100%]
================================= FAILURES =================================
_______________________________ test_answer ________________________________
    def test_answer():
>       assert inc(3) == 5
E       assert 4 == 5
E        +  where 4 = inc(3)
test_sample.py:6: AssertionError
========================= short test summary info ==========================
FAILED test_sample.py::test_answer - assert 4 == 5
============================ 1 failed in 0.12s =============================
```

### 常用命令

`熟悉测试命令和备忘, 了解常用参数含义`
```bash
pytest -s 输出print和日志
    --pdb 允许pdb调试
    -vv 详细输出
```

#### Django
```bash
python2 manage.py test tests/ # Django Test
```
#### Allure

```bash
pytest --alluredir=./allure_report
allure serve ./allure_report
```
### 安装
`涉及到的库和依赖安装命令备忘`

```bash
apt install npm
apt install openjdk-11-jdk
npm install -g allure-commandline --save-dev

pip install pytest
pip install allure-pytest
# -i https://pypi.tuna.tsinghua.edu.cn/simple
```

## 二、API测试
`批量API测试简化写法, 初步体验一下简化工作的快乐`
### 简单且重复的接口测试 **以CSV为例**

#### `test.csv`

url|body|contains
---|---|---
https://httpbin.org/post|{"key": "value"}|{"url": "https://httpbin.org/post"}
https://httpbin.org/post|{"key": "value"}|{"data": "{\"key\": \"value\"}"}

#### `test_api.py`

```python
def readCsv():
   data=list()
   with open('test.csv','r') as f:
      reader=csv.reader(f)
      next(reader)
      for item in reader:
         data.append(item)
   return data

@pytest.mark.parametrize('data', readCsv())
def test_csv_login(data):
    r=requests.post(
        url=data[0],
        json=json.loads(data[1]))
    _temp = r.json()
    _temp_update = copy.deepcopy(_temp)
    _temp_update.update(json.loads(data[2]))
    assert _temp == _temp_update
```

> 输出

```bash
pytest test_api.py

==================================== test session starts ====================================

platform linux -- Python 3.9.2, pytest-7.2.1, pluggy-1.0.0

rootdir: /mnt/share/code

plugins: allure-pytest-2.12.0, anyio-3.6.2

collected 2 items

  

test_api.py ..                                                                        [100%]

===================================== 2 passed in 3.12s =====================================

```

## 三、Mock 和测试

`了解测试中常用的小工具, 增进开发自测幸福感`
- 前、后端并行开发, 摆脱依赖
- 模拟无法访问的资源
- 隔离系统, 避免脏数据干扰或生产脏数据
### 0. Mock的方式
#### i. 手动指定 `mock` 范围

```python
def test_get_sum():
    mock_get_sum = mock.patch("app.get_sum", return_value=20)
    mock_get_sum.start()
    rst = app.get_sum(1, 3)
    mock_get_sum.stop()
```

#### ii. 装饰器

```python
@mock.patch("app.get_sum")
def test_get_sumv2(mock_get_sum):
    mock_get_sum.side_effect = mock_sum
    rst = app.get_sum(1, 3)
    assert rst == 10
```

#### iii. 上下文管理器

```python
with mock.patch("app.get_sum", new_callable=mock_sum) as mock_get_sum:
    rst = app.get_sum
    assert rst == 10
```

  

#### 总结

-|手动指定|装饰器|上下文管理器
---|---|--|--
优点|可以更精细控制mock的范围|方便mock多个对象| 1
不足|需要手动start和stop|装饰器顺序和函数参数相反容易混乱|一个with只能mock一个对象

### 1. Mock一个方法
```python
from pathlib import Path
def test_getssh(monkeypatch):
    monkeypatch.setattr(Path, "home", mockreturn)
```

### 2. Mock一个类

`以 requests 为例, mock get 任意url的(.json())返回值`
```python
import requests
class App:
    def get_json(self, url):
        return requests.get(url).json()

class MockResponse:
    @staticmethod
    def json():
        return {"mock_key": "mock_response"}

def test_get_json(monkeypatch):
    def mock_get(*args, **kwargs):
        return MockResponse()
        
    monkeypatch.setattr(requests, "get", mock_get)
    result = App().get_json("https://fakeurl")
    assert result["mock_key"] == "mock_response"

```

### 3. 实例

#### **backent - Django Test**

```python
from django.test import TestCase
from events.preview_service import PreviewService

class MailTestCase(TestCase):
    def setUp(self):
        pass

    @patch('events.preview_service.get_app_platform_logo')
    @patch('events.preview_service.is_master_node')
    def test_preview_info_master(self, mock_node, mock_logo):
        mock_node.return_value = True
        base64_image = "R0lGODlhAQABAIAAAAUEBAAAACwAAAAAAQABAAACAkQBADs=" # 黑色图片
        mock_logo.return_value = (2000, base64_image)
        cnt = PreviewService({
            "notice_object": "customer",
            "event_object": {
                "event_list": [
                {
                    "start_time": "2023-01-16",
                    "end_time": "2023-01-16",
                    "customer_name": "6",
                }
            ]}
        }).get_preview_info()
        self.assertEqual(type(cnt), dict)
        self.assertEqual(cnt.keys(), {"flag": None, "preview_info": None, "sender": None}.keys())
        self.assertEqual(cnt["flag"], True)
        self.assertEqual(cnt["sender"]["address"], "mdr@nsfocus.com")
        self.assertEqual(cnt["preview_info"]["email_title"], u"【绿盟科技1】MDR威胁分析服务安全事件通知")
```

#### **MOC**

```python
from common.nscloud import NsCloudNuriClient
class MockResponse:
    @staticmethod
    def json():
        return {"results": []}

def test_a(monkeypatch):
    def mock_request(*args, **kwargs):
        return MockResponse()
    monkeypatch.setattr(NsCloudNuriClient, "request", mock_request)
    # import pdb; pdb.set_trace()
    content = generate_daily_report_content("", "")
    assert bool(content)
```

## 四、功能重用(pytest.fixture)

`fixture一点需要考虑的是初始化与清理。`

- 也就是说在一个完整的测试用例中, 都必须都得有初始化与清理的部分, 这样才是一个完整的测试用例的
- 还有一点是`fixture`的函数也可以和返回值整合起来构成完整流程, 以`get`案例, 那么首先需要`add`书籍, 然后是`get`, 最后是`del`

```python
#!coding:utf-8
import pytest
import  requests
from loguru import logger

def add_book(get_token):
    r=requests.post(
        url='https://www.example.org/',
        headers={'Authorization':'JWT {0}'.format(get_token)}
    )

del_book = add_book # 仅演示用

@pytest.fixture()
def init(get_token):
    add_book(get_token)
    logger.info("add_book in init")
    yield
    del_book(get_token)
    logger.info("del_book in init")

def test_get_book(init, get_token):
    r=requests.post(
        url='https://www.example.org/',
        headers={'Authorization':'JWT {0}'.format(get_token)}
    )
    logger.info("get_book in test")
    assert r.text
```

  

### fixture作用范围(scope)

`@pytest.fixture()`如果不写参数, 默认就是`scope="function"`
它的作用范围是每个测试用例来之前运行一次, 销毁代码在测试用例运行之后运行

*详细如下:*
- `function` 每一个函数或方法都会调用
- `class` 每一个类调用一次, 一个类可以有多个方法
- `module` 每一个`.py`文件调用一次, 该文件内又有多个function和class
- `session` 是多个文件调用一次, 可以跨`.py`文件调用, 每个`.py`文件就是module

**输出**
```bash
pytest test_api.py -s
test_api.py 2023-02-07 15:38:22.906 | INFO     | test_api:init:17 - add_book in init
2023-02-07 15:38:24.471 | INFO     | test_api:test_get_book:27 - get_book in test
2023-02-07 15:38:25.894 | INFO     | test_api:init:20 - del_book in init
================ 1 passed in 6.71s ================
```

## 五、流程规范(Allure)
- 同样以`add`, `get`, `del`为例
- 详参[这里](https://blog.csdn.net/qq_42610167/article/details/101204066) 和 [这里](https://www.w3cschool.cn/pytest/pytest-2is63m91.html)
```python
import allure
import pytest
import requests

@pytest.fixture(scope="session")
def login_setup():
    return "token"

@allure.feature("功能模块")
@allure.story("测试用例小模块-成功案例")
@allure.title("测试用例名称: 流程性的用例, 添加测试步骤")
def test_add_goods_and_buy(login_setup):
    '''
    用例描述:
    前置: 登陆
    用例步骤: 1.浏览商品 2.添加购物车  3.购买  4.支付成功
    '''
    with allure.step("step1: 浏览商品"):
        assert True

    with allure.step("step2: 添加购物车"):
        assert True

    with allure.step("step3: 生成订单"):
        # assert False
        assert True

    with allure.step("step4: 支付"):
        assert True

    with allure.step("断言"):
        assert True


@allure.feature("MDR服务邮件通知去绿盟云")
@allure.story("客户安全事件邮件通知去绿盟化")
@allure.link("https://inone.intra.nsfocus.com/jira/browse/MDR-4271")
@allure.title("标题1")
def test_f1():
    '''
    用例描述:
    前置: 无
    用例步骤: 1.测试1 2.测试2
    '''
    with allure.step("step1"):
        assert True

    with allure.step("step2"):
        assert True
```

![[pytest-demo.jpg]]