---
title: Python笔记(notes of Python)
date: 2017-07-01 21:20
modified: 2022-04-27 18:30
category: [note, python, learning]
tags: [python, learning]
slug: notesPython
---
author:Ian

![python](https://www.python.org/static/img/python-logo@2x.png)

## 彻底摆脱`to_dict`和`from_dict`
### 使用 `pydantic`
`BaseModel`类型支持:
- b = BattleAxiePositionInfo.parse_obj(DICT_DATA)
- b.json()
- b.dict()
- parse_file
- parse_raw
```py
from pydantic import BaseModel
class PositionInfo(BaseModel):
    error: int = -1 # 收集错误
    none: int = 0 # 还没开始
    clicked: int = 1 # 在client 赋此值
    done: int = 2 # 在server 赋此值
    xy: List[int] = [0, 0]
    status: int = 0 # clicked or done or none or error
class BattleAxiePositionInfo(BaseModel):
    our: List[PositionInfo] = [PositionInfo(), PositionInfo(), PositionInfo(), PositionInfo(), PositionInfo(), PositionInfo()]
    enemy: List[PositionInfo] = [PositionInfo(), PositionInfo(), PositionInfo(), PositionInfo(), PositionInfo(), PositionInfo()]

pp = BattleAxiePositionInfo()
print(f"pp json: {pp.json()}")
dict_pp = pp.dict()
pp = BattleAxiePositionInfo.parse_obj(dict_pp)
```

>>> pp json: {"our": [{"error": -1, "none": 0, "clicked": 1, "done": 2, "xy": [0, 0], "status": 0}, {"error": -1, "none": 0, "clicked": 1, "done": 2, "xy": [0, 0], "status": 0}, {"error": -1, "none": 0, "clicked": 1, "done": 2, "xy": [0, 0], "status": 0}, {"error": -1, "none": 0, "clicked": 1, "done": 2, "xy": [0, 0], "status": 0}, {"error": -1, "none": 0, "clicked": 1, "done": 2, "xy": [0, 0], "status": 0}, {"error": -1, "none": 0, "clicked": 1, "done": 2, "xy": [0, 0], "status": 0}], "enemy": [{"error": -1, "none": 0, "clicked": 1, "done": 2, "xy": [0, 0], "status": 0}, {"error": -1, "none": 0, "clicked": 1, "done": 2, "xy": [0, 0], "status": 0}, {"error": -1, "none": 0, "clicked": 1, "done": 2, "xy": [0, 0], "status": 0}, {"error": -1, "none": 0, "clicked": 1, "done": 2, "xy": [0, 0], "status": 0}, {"error": -1, "none": 0, "clicked": 1, "done": 2, "xy": [0, 0], "status": 0}, {"error": -1, "none": 0, "clicked": 1, "done": 2, "xy": [0, 0], "status": 0}]}

## 多个类属性一次赋值
No:
```
self.a = a
self.b = b
```
Yes:
```
self.__dict__.update({"a": a, "b": b})
```
## 列表表达式 二维数组边一维 取字典内变一维
```
knowninfo = {'axie_id3': {'init_cards': ['Sunder Claw', 'October Treat', 'Gas Unleash', 'Disguise'], 'sort': 4}}
[vv for _,v in knowninfo.items() for vv in v["init_cards"]]
# ['Sunder Claw', 'October Treat', 'Gas Unleash', 'Disguise']
```
## PiP Not Found Issue
使用`pip`安装某包时， 提示让更新， 按提示操作更新没效果没反应再用就提示`ModuleNotFoundError: No module named 'pip'` (ˉ▽ˉ；)...

## ModuleNotFoundError: No module named 'pip'
### 升级`PiP`时出现问题可由下方命令修复
```
python -m ensurepip
python -m pip install --upgrade pip
```
## SSL校验
安装EasyOCR时,
`reader = easyocr.Reader(['ch_sim','en'])`
下载到接近90,结果报错了.... 估计是SSL问题加入以下两条,不知如何.
```py
import ssl
ssl._create_default_https_context = ssl._create_unverified_context
```

from http.client
`To revert to the previous, unverified, behavior ssl._create_unverified_context() can be passed to the context parameter.`

### 使用国内镜像下载Python
```shell
	pip install --index https://pypi.mirrors.ustc.edu.cn/simple/ dlib(numpy等包名)
    # 一键更新pip 包资源(利用管道grep传输查询到的需要更新包名，传输到install命令)
    pip3 freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip3 install -U
    # 权限不够的话就在`pip3 install` 之前加`sudo`反正我不习惯用`root`
```

### 声明参数类型
python3 在定义函数的时候可以声明函数类型啦：虽然不做限制，但作为`label`还是蛮好的。
```py
import io

def add(x:int, y:int) -> int:
    return x + y

def write(f: io.BytesIO, data: bytes) -> bool:
    try:
        f.write(data)
    except IOError:
        return False
    else:
        return True
```
终于不会之后写的忘了，要调用函数还得看半天这个函数应该怎么用…

### 时间处理
以下可以做周、月的加减处理
relativedelta examples
Let’s begin our trip:

```
from datetime import *; from dateutil.relativedelta import *
import calendar
```

#### Store some values:

```
NOW = datetime.now()
TODAY = date.today()
NOW
```
> datetime.datetime(2003, 9, 17, 20, 54, 47, 282310)
```
TODAY
```
> datetime.date(2003, 9, 17)

#### Next month

>>> NOW+relativedelta(months=+1)
```
datetime.datetime(2003, 10, 17, 20, 54, 47, 282310)
```

### 合并字典
```python
a = {}
b = {'a': 1}
c = {**a, **b}

```
key重复`b`中覆盖`a`, 否则单纯合并。

### 聊胜于无的小玩意 preety tools
##### 彩色输出
模块名儿忘了，以后贴2019.03.01  03:08
one minute later:
`pip3 install ansicolors`
```
from colors import red, green, blue
print(red('This is red'))
print(green('This is green'))
print(blue('This is blue'))

from colors import color
for i in range(256):
    print(color('Color #%d' % i, fg=i))
```
以上程序只能写在`.py`文件中,运行，而不能在…‘偷懒模式‘中。
#### Python3 ThreadPoolExecutor 线程池内库
在`python3`之后不久，有关线程池的使用就被集成到内库之中。
`from concurrent.futures import ThreadPoolExecutor`
使用方法：
```
    ThreadPoolExecutor(max_workers=12)
    # 设置线程池大小
    .submit(func_name, (para))    # 提交任务
    .done()    # 查看任务是否完成
    .cancel()    # 没有被放入线程池中才能生效
    .result()    # 获取该任务返回值

    from concurrent.futures import as_completed
    # 用于取出所有任务结果，省去一直用.done去查看的繁琐。但该方法
# 是一个生成器，所以任务未完成会阻塞。 还有 wait map 等用法就去看文档吧。
```
##### 安装错误？
居然有`pip3 install XX`的错误…这也是因为有旧版`pip3`存留。需要
```shell
$bash -d pip3 
$bash -r pip3
```
来清理shell中旧版pip缓存。

### IDE?
其实要不要IDE都无所为，因为本就是脚本，要IDE只能说打开一个陌生项目查看时能够跳转函数。至于`vim`大概不能跳转吧，毕竟跳转需要把文件都加载才能实现。emm  来来，IDE的话就`PyCharm`除了编程页面颜色难看之外其他功能都不错，另外不支持中文路径，不过应该不是由于`Python`语言造成的，因为蟒蛇脚本是可以在中文路径下运行di<date:2018年5月28日17点16分>
#### print语句： 含有自动换行，所以要想不换行的话需要在结尾加一个","如：	  
	for i in range(0,5):

		print i,

而Python3版本则应该也可以 print(a,b,c);然而Python2.7不行

#### 根据字典中值大小排列：
	sorted(dict2.iteritems(),key=lambda item:item[1],reverse=True) 
	# item[0]即根据键来排列[1]为根据对应值

#### format：如:
	print('my name is{0},and my age is{1}'.format('song',18))

##### or:
	url = 'http://www.google.com/page={}/'

	newsurl = url.format(i)
	# 旋即其后内容则代替{}位置
另，在{a}{b}{c}可通過format(a=1,b=2,c=3)來賦值


---


### BeautifulSoup
#### select语句：在内容前加'#'可以获得其内容，如：
	soup.select('artibodyTitle')[0].text
	select().contents
	"""
	把标签变成不同list，同List中的不同元素 然后用[0]可取得第一个元素内容，而不与后方的内容合到一起
	*.strip()可将取出的‘\t\t’移除
	"""
	.select('time-source span a')
	# 从time-source中的<span下<a下取得内容e
	.select('.productPrice')[0].text
	# 獲取class="productPrice"下價格內容


---


### datetime字符串转时间  时间转字符串:
	from datetime import datetime
	dt = datetime.strptime(timesource,'%Y年%m月%d日%H:%M')(****年*月*日*22:03)
	dt.strftime('%Y-%m-%d')

---

### 保存數據到xlsx，sqlite3、csv：
	.to_excel('name.xlsx')：输出为excle文件
	import sqlite3  #保存到数据库
	with sqlite3.connect('name.sqlite') as db:
		df.to_sql('name',con = db)
#####  从数据库取出
	with sqlite3.connect('name.sqlite') as db:
		df2 = pandas.read_sql_query('SELECT' * FROM name',con = db)
#### 類型錯誤 TypeError: a bytes-like object is required, not 'str'
	csv_file = open("rent.csv","wb")    
	csv_writer = csv.writer(csv_file, delimiter=',')    #创建writer对象，指定文件与分隔符
	writer.writerow(['title', 'summary', 'year', 'id', 'count', 'link'])

Python2.7 轉到 3.5下時提示由此錯誤，代碼爲
##### 原因，解決方法：
	因爲Python3.5 對於str與bytes類型區分變得敏感，所以原本在2.7下正常的代碼不能正常運行。
	雖然，利用str.encode() 或者 str = bytes(str, encoding = 'utf-8')可以轉換格式
	然而錯誤依然有……解決辦法則是放棄論壇裏的說法，找到官網Demo
##### 更改如下：
```python
	csvfile = open('goodsList.csv', 'w', newline='')
	spamwriter = csv.writer(csvfile, delimiter=',')
	spamwriter.writerow([productTitle, productPrice, productShop])
```
細節在於，在打開文件的時候去除`wb`裏面的`b`即不用二進制模式打開。


---

### Image下：
获取图像分辨率：
```python
	im = Image.open(0.0)
	width = im.size[0]
	height = im.size[1]
```

---

### Pandas:
```python 
	box = pd.read_csv("filename.csv, index_col="Date", parse_dates=Ture) 
	#读入文件，讲Date作为日期
	box.columns = ['',''] 
	# 更改列名
	box['new'] = box['1']+box['2']
	# 新增一列为1与2之和
	box.resample('d', 'sum') 
	# 重新按照‘d’:每天，进行采样  方式为取和('w','sum')所有数据在一周内进行取和
```

## 闲语：
#### while True与while 1的区别：
在Python2 中，循环判断一亿次，我的小电脑的执行速度是
	
    while one: 9.97739481926
    while_true: 18.8063299656
    while 1 以压倒性胜利。
    
到了Python3中，则成了
	
    while one: 16.101972927001043
    while_true: 16.25536527499935
    
>嗯，不错，不分伯仲——个鬼啊。整体变差了好吧。0.0   原因待明。

[^_^]:
	hello你好啊.你还认识我吗？我感觉不成.我去,居然成了:怎么回事！！！难道就win比较傻[2018年5月18日不是今天写的啊，只是发现这么个东西，然后，也发现注释不能有空格]



# Python 小记 📖
先贴一个客观的教程文档网站<http://www.runoob.com/python/python-tutorial.html>
#### Windows 下添加环境变量，CMD中Python2 与Python3 共存
Windows 下 把python2 路径加入到环境变量中，再修改python2.exe可以和python3区分方便在CMD中调用，但代价就是经常命令报错……

不过也可以使用py -2来区分，所以还是不改名字了吧
Windows 下 用`py -2 -m pip install ***`以及`py -3 -m pip install ***`来区分安装到python2 或者 python3.

### 变量
类下直接定义的变量可以继承，然而并不能被自己的函数所调用，意义不明…

被继承的类可以调用继承类中定义的self.* 变量，俺认为这是因为它们在实例时都被当成了self 本身。另外，优先调用自己中的self变量，没有，才会去被继承类中去查找（先后顺序可得前方解答）。

## 变换数据类型
Python 在从服务器接收或者发送数据时需要字符类型转换，'''struct'''便是为此而工作
#### struct.pack
```py
    import struct
    a = 20
    b = 400
    str = struct.pack("ii", a, b)  
    #转换后的str虽然是字符串类型，但相当于其他语言中的字节流（字节数组），可以在网络
    #上传输
    print 'length:', len(str)
    print str
    print repr(str)
```
> ---- result
> length: 8
        >    #----这里是乱码
> '/x14/x00/x00/x00/x90/x01/x00/x00'

格式符”i”表示转换为int，’ii’表示有两个int变量。进行转换后的结果长度为8个字节（int类型占用4个字节，两个int为8个字节），可以看到输出的结果是乱码，因为结果是二进制数据，所以显示为乱码。可以使用python的内置函数repr来获取可识别的字符串，其中十六进制的0x00000014, 0x00001009分别表示20和400。

#### struct.unpack
```py
    str = struct.pack("ii", 20, 400)
    a1, a2 = struct.unpack("ii", str)
    print 'a1:', a1
    print 'a2:', a2
```
> ---- result:
> a1: 20
> a2: 400

struct.unpack做的工作刚好与struct.pack相反，用于将字节流转换成python数据类型。它的函数原型为：struct.unpack(fmt, string)，该函数返回一个元组。

#### struct.calcsize
```python
    struct.calcsize('i')
    struct.calcsize('ii')
    struct.calcsize('iic')
    struct.calcsize('iicd')
```
> 4
> 8
> 9
> 24

`struct.calcsize`用于计算格式字符串所对应的结果的长度，如：`struct.calcsize(‘ii’)`，返回`8`。因为两个`int`类型所占用的长度是`8`个字节。

#### struct.pack_into, struct.unpack_from
```python
    import struct
    from ctypes import create_string_buffer

    buf = create_string_buffer(12)
    print repr(buf.raw)
    struct.pack_into("iii", buf, 0, 1, 2, -1)
    print repr(buf.raw)
    print struct.unpack_from('iii', buf, 0)
```

>---- result
>'/x00/x00/x00/x00/x00/x00/x00/x00/x00/x00/x00/x00'
>'/x01/x00/x00/x00/x02/x00/x00/x00/xff/xff/xff/xff'
>(1, 2, -1)

## Python3 
在<font color=red>Python3</font>中，转换字符串时，不能直接`pack('8s', 'i am str')`, 需要将字符串转换成二进制所以在语法中标记`pack('8s', b'i am str')`使用`'b'`来进行标记

以上来自[Darkbull](http://python.jobbole.com/81554/) 这是转贴地址，不知道为什么我看的转贴挂的原帖地址失效了 😰

---

---

---

### 一不小心发现的语法
<font color=red>py2.7</font>

    while 'a' in a or b:
        break
    # 没错，意思就是如果a或者是b包含‘a’的话…     

### \* 与 ** 方法:
呃，原来`*`在MarkDown里面是斜体的意思啊——需要斜体显示的前后各一个星号

    def a(* a, **b):
        balabala
这里的*a， a在函数中被赋值为一个元组，b被赋值为一个字典。所以在调用的时候嘞，只能把能往一个元组里塞的放在前面，而能够生成字典的放在后面
    
    a(1,2,3,4,5,6,7,8,9,a:'a',b:1,c:'nihao')
就像这么一样来调用。  另外，def a()函数中还能在前方再新加一个输入

    def aa(jiushishuowo, *a, **b):
        pass
这样的话，那么在调用的时候第一个逗号前面的内容会赋值给它。over，回去拿快递了~~~

🐶 年假前再来补充一下：约定名*args, **kwargs

#### 获取文件路径
    path = os.path.abspath(os.path.dirname(__file__))
    # 获取当前运行文件的路径。需在本地有此文件，在命令行中出错
    
    for root, subdirs, files in os.walk(path):
    # 遍历所有path下文件  path为要遍历的路径

#### 同获取路径
    os.path.abspath('./')
    os.path.abspath('Deskop')
    os.path.abspath('Deskop') + os.path.sep
>'C:\\Users\\Administrator'

>'C:\\Users\\Administrator\\Deskop'

>'C:\\Users\\Administrator\\Deskop\\'

### 获取指定目录下所有文件名列表
    os.listdir('D\IFData')

---

##### \__dict__
    class Province:
        country = 'China'

        def __init__(self, name, count):
            self.name = name
            self.count = count

        def func(self, *args, **kwargs):
            print 'func'

    print Province.__dict__     # 类输出
    obj1 = Province('HuBei', 100)
    print obj1.__dict__         # 对象1
    obj2 = Province('hulala', 3888)
    print obj2.__dict__         # 对象2

>`{'country': 'China', '__module__': '__main__', 'func': <function func at 0x049EF470>, '__init__': <function __init__ at 0x049EF4F0>, '__doc__': None}`

>`{'count': 100, 'name': 'HuBei'}`

>`{'count': 3888, 'name': 'hulala'}`

类输出的是全局的函数，变量等信息。 
对象输出的只是对象拥有的普通变量而已

呃(⊙﹏⊙)，等下再去拿吧…  差点忘了说，这个__dict__与字典相配合来回赋值简直舒服… 步骤为：将某个变量=一个类（数据类（就是能够a.b这么调用的数值））然后这个变量就能a.b的这么使用了。  而后也能通过a.__dict__（这是一个字典）再将所需要的数值取出来，转赋值为别的东西。  反正我是用到了… 在想要实现一个函数来保存一个变量的某些属性的时候。（呃(⊙﹏⊙)用爱去理解我所描述的场合吧。）


### IF ELSE
    # 执行时会将IF前面整个表达式作为判断结果后的执行对象，
    # 而不是仅仅替换某一个数字或者变量。  即 下方表达式运算结果
    # 不是  `4`       和      `5`  而是如下所示
    a = 1 + 3 if 1 == 2 else 2 + 1
    a
    a = 1 + 3 if 1 == 1 else 2 + 1
    a
> 3

> 4

---

---

---

### Python 2 中的object新式类和经典类
    # 作者：邹冲
    # 链接：https://www.zhihu.com/question/19754936/answer/202650790
    class A:
        def foo(self):
        print('called A.foo()')

    class B(A):
        pass

    class C(A):
        def foo(self):
        print('called C.foo()')

    class D(B, C): 
        pass

    if __name__ == '__main__':
        d = D() 
        d.foo()

> B、C 是 A 的子类，D 多继承了 B、C 两个类，其中 C 重写了 A 中的 foo() 方法。

> 如果 A 是经典类（如上代码），当调用 D 的实例的 foo() 方法时，Python 会按照深度优先的方法去搜索 foo() ，路径是 B-A-C ，执行的是 A 中的 foo() ；

> 如果 A 是新式类，当调用 D 的实例的 foo() 方法时，Python 会按照广度优先的方法去搜索 foo() ，路径是 B-C-A ，执行的是 C 中的 foo() 。

> 因为 D 是直接继承 C 的，从逻辑上说，执行 C 中的 foo() 更加合理，因此新式类对多继承的处理更为合乎逻辑。

> 在 Python 3.x 中的新式类貌似已经兼容了经典类，无论 A 是否继承 object 类， D 实例中的 foo() 都会执行 C 中的 foo() 。但是在 Python 2.7 中这种差异仍然存在，因此还是推荐使用新式类，要继承 object 类。

#### .items()
一个字典 a，其a.items()为将每对对应值组为一个元组。即使键值也为一个字典也是将此字典作为元组元素。(￣▽￣)" emm

---

---

### Queue
队列，先进先出型。可存数字、字符…嘛，Python里啥都一样。所以啥都能存。用于事件按顺序执行。示例如~：
    
    import Queue
    mqueue = Queue.Queue(maxsize = 3)
    mqueue.put(10)
    mqueue.put(15)
    mqueue.put(12)
    # 此时如果再往里存呢，就会卡住… 持续等待有空位置
    # 所以
    mqueue.get()        #取出第一个存入
    mqueue.put('14sas4')  #继续存
    ## 在接触的项目中，是借用字典，来将处理函数作为Value，将Keys，put到队
    列中，再进行取出执行。

如果队列中没有数值之后再`get`也会卡住……
所以以下东西就显得比较重要了：
    

### series和dataframe
先贴来源：<http://blog.csdn.net/ly_ysys629/article/details/54944153>

##### 属性
    series    ：.index, .values, .name, .index.name
    dataframe ：.columns, .index, .values

##### <font color=red>series</font>:
一组数组（列表或元组），series除了一组数据外还包括一组索引（即只有行索引），索引可自行定义也可利用Series(),自动生成索引;
##### <font color=red>dataframe</font>:
是表格型数据，既有行索引又有列索引，每列数据可以为不同类型数据（数值、字符串、布尔型值），可利用DataFrame（其他数据，dataframe属性)指定dataframe的属性创建dataframe。

##### 实例
##### series
    #创建series
    import pandas as pd
    obj_list=[1,2,3,4]
    obj_tuple=(4,5,6,7)
    obj_dict={'a':[1,2],'b':[2,3],'c':[3,4],'d':[4,5]}
    obj_series_list=pd.Series(obj_list)#通过列表创建series
    obj_series_tuple=pd.Series(obj_tuple,index=list('abcd'))
    #通过元组创建series
    obj_series_dict=pd.Series(obj_dict)#通过字典创建series
    #定义属性
    obj_series_list.index.name='zimu'
    obj_series_list.name='data'

    print "#通过列表创建series"
    print obj_series_list
    print "#通过元组创建series"
    print obj_series_tuple
    print "#通过字典创建series"
    print obj_series_dict
    #显示series类型及属性
    print type(obj_series_list),obj_series_list.dtype
    print obj_series_list.index,obj_series_list.index.name
    print obj_series_list.values,obj_series_list.name

> #通过列表创建series

>zimu

>0    1

>1    2

>2    3

>3    4

>Name: data, dtype: int64

---

>#通过元组创建series

    a    4
    b    5
    c    6
    d    7
    dtype: int32

---

>#通过字典创建series

    a    [1, 2]
    b    [2, 3]
    c    [3, 4]
    d    [4, 5]
    dtype: object
    <class 'pandas.core.series.Series'> int64
    RangeIndex(start=0, stop=4, step=1, name=u'zimu') zimu
    [1 2 3 4] data

##### dataframe
    #创建dataframe
    import pandas as pd
    import numpy as np
    obj_dict={'a':[1,2],'b':[2,3],'c':[3,4],'d':[4,5]}
    obj_array=np.array([[1,2,3,4],[3,4,5,6]])
    obj_series_1=pd.Series([11,12,13,14])
    obj_series_2=pd.Series([21,22,23,24])
    obj_dataframe_dict=pd.DataFrame(obj_dict)
    #通过字典创建dataframe
    obj_dataframe_array=pd.DataFrame(obj_array,index=['one','two'])
    #通过矩阵创建dataframe
    obj_dataframe_series=pd.DataFrame([obj_series_1,obj_series_2])
    #通过series创建dataframe
    obj_dataframe_dataframe=pd.DataFrame(obj_dataframe_series,index=
        [0,1,'one'],columns=[0,1,2,'a'])
    #通过其他dataframe创建dataframe
    print "#通过字典创建dataframe"
    print obj_dataframe_dict
    print "#通过矩阵创建dataframe"
    print obj_dataframe_array
    print "#通过series创建dataframe"
    print obj_dataframe_series
    print "#通过其他dataframe创建dataframe"
    print obj_dataframe_dataframe
    #dataframe属性
    print obj_dataframe_dataframe.dtypes
    print obj_dataframe_dataframe.values
    print obj_dataframe_dataframe.columns
    print obj_dataframe_dataframe.index
> 输出结果为：
    #通过字典创建dataframe
       a  b  c  d
    0  1  2  3  4
    1  2  3  4  5
    #通过矩阵创建dataframe
         0  1  2  3
    one  1  2  3  4
    two  3  4  5  6
    #通过series创建dataframe
        0   1   2   3
    0  11  12  13  14
    1  21  22  23  24
    #通过其他dataframe创建dataframe
            0     1     2   a
    0    11.0  12.0  13.0 NaN
    1    21.0  22.0  23.0 NaN
    one   NaN   NaN   NaN NaN
    0    float64
    1    float64
    2    float64
    a    float64
    dtype: object
    [[ 11.  12.  13.  nan]
     [ 21.  22.  23.  nan]
     [ nan  nan  nan  nan]]
    Index([0, 1, 2, u'a'], dtype='object')
    Index([0, 1, u'one'], dtype='object')
取数据的话，便是`obj_dataframe_dict['a'][0]`取出数值即为`1`
### 自命名创建方式
    df4 = pd.DataFrame(np.random.randn(6, 4), 
        index=[u'第二', 4, 3, 2, 1, 0], columns=[u'第一',5,4,1])
    #行为：     第一，      5，         4，         1
    #列为：第二 -0.091305   ...
    #       4   ...
    #       3
    #       2
    #       1
    #       0                                       ...
### 查看
    .dtypes     查看各行数据格式
    .head()     查看前几行（默认5）
    .tail()         查看后几行
    .index      查看数据框引索
    .columns        查看列名
    .values     数据值
    .T          转置
    .sort           排序  .sort(columns = '***')根据***列数据进行排序


###### <font color=green>取数据方法见上</font>

### zip 和 数组变字典
    a = [1,2,3]
    b = [4,5,6]
    c = [4,5,6,7,8]
    zipped = zip(a,b)
>[(1, 4), (2, 5), (3, 6)]

    zip(a,c)
>[(1, 4), (2, 5), (3, 6)]

    zip(*zipped)
>[(1, 2, 3), (4, 5, 6)]

zip 也可以二维矩阵变换（矩阵的行列互换） 
因为其作用为按序号重组数组。（其英语翻译为拉链……）

#### 数组变字典~：
    dic(zip(a, b))
    # a中值为key b中值为values

### 字典操作
    dict= sorted(dic.items(), key=lambda d:d[0]) 
    # 将字典按照键值升序排列
    # d： 无所谓的参数
    # d[0]：0为升序，1为降序
    # 如果是字符型，那么‘1’‘10’‘12’… 才是‘2’’20‘，因为Python的比较是按照
        # 按序提取第一个字符进行比较。所以要排序，还是得用int
    # 排序之后被转换为list类型。
    for i in orderIDic:
                spamwriter.writerow(orderIDic[i])
    # 变为
    for i in orderIDic:
                spamwriter.writerow(i[1])

---

#### namedtuple
    import collections
    person = collections.namedtuple('P', 'name age gender')
    # P: 类名   后面空格隔开的为变量名称
    
    bob = person(name = 'B', age = 30, gender = 'male')
    jane = Person(name = 'J', age = 29, gender = 'female')
    for people in [bob, jane]:
        print ("%s is %d years old %s" % people)

元组的命名—— 命名之后可以由bob.name 来调用 （看了那个Python面向对象进阶， 老多`__hahah__()`函数之后，所以这明显是当成基本类的变量在用了。  emm 这么么说也不贴切 😔  果然理解程度还是跟不上的…    emm 现在需要跟进的不是怎么用Python了，而是python的用法了，走起~  继续写future笔记去了—— 这个得看的明白点儿😄）


---

---

### CSV
#### 读取
    import csv
    reader = csv.reader(open('test.csv', 'rb')) 
    for item in reader:
        print item
##### 官方是这么教你的
    #我记得我写过一次，怎么不见了…
    import csv
    with open('names.csv') as csvfile:
        reader = csv.DictReader(csvfilr)
        for row in reader:
            print (row['first_name'], row['last_name'])
#### 写入
    import csv
    writer = csv.writer(open('test2.csv', 'wb'))
    writer.writerow(['col1', 'col2', 'col3'])
    data = [range(3)  for i in range(3)]
    for item in data:
        writer.writerow(item)
##### 官方教你这么写
    import csv
    with open('names.csv') as csvfile:
        fieldnames = ['first_name', 'last_name']
        writer = csv.DictWriter(csvfile, fieldnames = fieldnames)
        
        writer.writeheader()
        writer.writerow('first_name' : 'Naled', 'last_name' : 'Beans')

须注意之处：writer.writerow()方法中的参数是list类型，如果你想在A1列写入'hello'，则必须是writer.writerow('hello')，不然'hello'会被看成是个list从而被分写入5列。写入CSV时，CSV文件的创建必须加上'b'参数，即csv.writer(open('test.csv', 'wb'))，不然会出现隔行的现象。网上搜到的解释是：python正常写入文件的时候，每行的结束默认添加'\n’，即0x0D，而writerow命令的结束会再增加一个0x0D0A，因此对于windows系统来说，就是两行，而采用’b'参数，用二进制进行文件写入，系统默认是不添加0x0D的。
#### 关闭
    csvfile.close()

值得注意的是上面的文档是覆盖型创建，即，写数据只能在关闭文档之前完成，之后再打开文件，再写就会覆盖掉之前（清空再写） 下面的txt  `mode = 'a'` 就属于添加型写入了，再关闭之后再打开会在最后一条开始继续添加。然后将csv中的'w'替换成‘a’就行了。记得带上'b'要不会出现数据隔行…隔行显示
##### 官方还叫你这么写嘞
    with open('na1me.csv', 'ab') as csvfile:
        spamwriter = csv.writer(csvfile, delimiter = ',')
        spamwriter.writerow(['adasd', 'w.c.w', 'lol'])
### txt保存
    # 基本与CSV一致，emm其实都是保存为文档，就只有个后缀区别…
    def text_save(content,filename,mode='a'):
        # Try to save a list variable in txt file.
        file = open(filename,mode)
        file.write(str(content)+'\n')
        file.close()
    text_save(np.mean(self.trueRange[start: ]), 'atr.txt')

关于保存路径呢，windows 下必须<font color=green>?</font>用  ‘.\\.\\..’没错，当前路径（相对路径）和绝对路径都是这样用的

`mode` `b`代表二进制模式打开，而`a`就有用了，表示有此文件就打开，没的话就创建。

### json
    和上述txt文件保存差不过，嗯应该说完全一样。因为我是用的是`json.dumps`
#### dumps、loads
        这两个语句前者是将字典转化为str格式，后者是将str转换为字典。所以保  
    存到文件也不过是 字典 -> str ->(用`write`写入)-> 本地文件， 反之。
        与之相对比的是`dump`和`load`这个是直接保存至文件，但`s`多好用
    需注意的是`dumps`有`indent`参数可用来指明转换为`str`之后的缩进参    
    数。一般`4`（所以说这里说的是空格数？）。  哦，`loads`直接加载文件也
    行，不用读出来`str`再去转换
    

### Shelve 
    对象的持久化存储——
    目的：Shelve模块为任意能够pickle的Python对象实现持久化存储，并提供一个类似字典的
接口。
---

---

---

## 列表List
<font color=red>需提前定义，不能像变量一样随用随写…</font>

以下来自于 [Python 列表(List)操作方法详解](http://www.jb51.net/article/47978.htm)
### 列表操作包含以下函数:
    cmp(list1, list2)       # 比较两个列表的元素 
    len(list)               # 列表元素个数 
    max(list)               # 返回列表元素最大值 
    min(list)               # 返回列表元素最小值 
    list(seq)               # 将元组转换为列表 
    
### 列表操作包含以下方法:
    list.append(obj)        # 在列表末尾添加新的对象
    list.count(obj)         # 统计某个元素在列表中出现的次数
    list.extend(seq)        # 在列表末尾一次性
        # 追加另一个序列中的多个值（用新列表扩展原来的列表）
    list.index(obj)         # 从列表中找出某个值第一个匹配项的索引位置
    list.insert(index, obj) # 将对象插入列表
    list.pop(obj=list[-1])      #移除列表中的一个元素（默认最后一个元素）
        #，并且返回该元素的值
    list.remove(obj)        # 移除列表中某个值的第一个匹配项
    list.reverse()          # 反向列表中元素
    list.sort([func])           # 对原列表进行排序

## 字符串连接
来自<http://www.cnblogs.com/chenjingyi/p/5741901.html>
### 方法一
    website = 'python' + 'tab' + '.com'
### 方法二
    listStr = ['python', 'tab', '.com'] 
    website = ''.join(listStr)
### 方法三
    website = '%s%s%s' % ('python', 'tab', '.com')
结论： 连接个数少使用一，个数多使用二。  推荐，使用三 ~ ，~

## 手动编译Py文件
    import compileall
    compileall.compile_dir(目录)

---

---

---

## 时间
#### datetime
    from datetime import datetime
    a = datetime.now().replace(hour=0, minute=0, second=0, microsecond=0) 
    a.year  
    a.hour      #int 型变量
>2017   

>0

>获取当前本机电脑💻时间，replace为自定义某个数值。单独调用某个信息如a.year、a.hour

#### datetime 类型变量可直接相减获得间隔日
    a = datetime.datetime.now()
    # datetime.datetime(2017, 10, 18, 8, 52, 27, 5000)
    b = datetime(2005, 2, 6)
    # datetime.datetime(2005, 2, 6, 0, 0)
    c = a - b 
    # datetime.timedelta(4637, 31947, 5000)
    c.days  # int 型
>4637
#### timedelta
timedelta为datetime类型相减而来（datetime不能相加…），然后嘞，datetime.timedelta(1,35340)这是它的样子，前是天数，后是秒数。也就是说所有相减就是告诉你相距多少天零多少秒，都是标准单位（误）。要取出可 `.days`   和  `seconds``
    
### 格式化输出当前时间
    import time
    print time.strftime('%Y-%m-%d %H:%M:%S',time.localtime(time.time()))
>2017-08-21 10:54:31

### time
    import time
    time.time()     # 返回当前时间的时间戳（1970纪元后经过的浮点秒数）
    # 返回值为float 可直接拿来运算，还是很舒服的。

---

---


### 线程 threading
#### 用于实现定时器
    import threading
    def hel():
        print "so you sucsessful to kill 5 seconde"
    time = threading.Timer(5, hel)
    time.start()
>so you sucsessful to kill 5 seconde
在命令行中按下回车后消失，很有意思，并且当第二调用时time.start()时就会——

>RuntimeError: threads can only be started once
#### 循环调用
以上的不能循环调用的话就没啥价值了，所以下面有个妖艳用法为：

    def fun():
        print "So jian"
        global timer
        timer = threading.Timer(5.5, fun)
        timer.start()
    timer = threading.Timer(1, fun)
    timer.start()
    # 通过自调自的方法循环创建时间线程，另外，timer.cancel()可停止定时器工作。
    # 值得注意的是，上面不循环调用的 在执行完函数之后依然会持续运行
    # 所以得记得关闭。
比方说这个妖艳……呃 本来打算在调用函数里写上cancel但是…依然之后不能再次start()

#### 线程<font color=#10e5a6>池</font>
自实现或者使用`threadpool.ThreadPool`:
```py
    import time
    import threadpool  
    def sayhello(str):
        print "Hello ",str
            time.sleep(2)

    name_list =['dd','aa','bb','cc']
    start_time = time.time()
    pool = threadpool.ThreadPool(10) 
    requests = threadpool.makeRequests(sayhello, name_list) 
    for req in requests:
        pool.putRequest(req) 
    pool.wait() 
    print '%d second'% (time.time()-start_time)
```


---

---

---
    
# Math 库
    import math
### 数值取整 
    ceil、floor    还有一个不是此库中的round
找来翻译就是 ： 小区、地板、回合………… 好吧，是（抹灰泥装镶板、最低的，最小的、周围，围绕）

    # 使用方法为：
    math.ceil(3.12)
    math.floor(3.24)
    round(3.51)
    round(3.10999999999, 10)
    #取值时的参考步长，好像（😭）是10就是最大步长了，再大没意义
    # 手动赋值超过9位也就是10位小数的时候在PyCharm里直接赋值调试就自己约了，
    # 而一般产生精度漂移都是十几位小数开外的。emm   就这么表达了，看得懂
>4.0

>3.0

>4.0

>3.11

---

---

---

---

# 令程序有序执行的方法
## 对象（伪类）间变量传递
Like This：

    class A(object):
    """docstring for A"""
        def __init__(self, name):
            super(A, self).__init__()
            self.name = name
            self.a = 0
        def da(self):
            print self.name
            print self.a    
    a = A('I am A')
    a.da()


    class B(object):
    """docstring for B"""
        def __init__(self, aclass):
            super(B, self).__init__()
            self.aclass = aclass
            self.aclass.a += 1
        def dada(self):
            self.aclass.da()
    b = B(a)
    b.dada()

    class C(object):
    """docstring for B"""
        def __init__(self, aclass):
            super(C, self).__init__()
            self.aclass = aclass
            self.aclass.a += 1
        def dada(self):
            self.aclass.da()
    c = C(a)
    c.dada()
>I am A

>0

>I am A

>1

>I am A

>2

B与C分别在去改变读取在A中定义的数值。  嗯，没错，这么看的画确实时Python基础……所以没有这个基础的我看起来前期还挺费劲。当然，理解很好理解，就是在实现方法上不知原理的话就很难过。最主要的是，知道了原理在自己编写的时候可以的心用手，信手拈来。嗯~ o(*￣▽￣*)o就是这么写意和惬意。在VN.PY中有记录，不过还是拿过来吧，毕竟python用法

---

## 字典中建立函数映射，方便调用~
    def add(x, y):
        return x + y
    def sub(x, y):
        return x - y
    a = {'add':add, 'sub':sub}
    a
    a['add'](1, 2)
    a['sub'](1, 2)
>{'add': <function add at 0x02D162B0>, 'sub': <function sub at 0x02D16530>}

>3

>-1

### collections 模块
#### namedtuple
    给元组元素命名（貌似写过这个笔记欸，不过现在才发现这几个都是在一个模块下的）
#### deque
    #双端队列  快速插入 以及取出
    l.insert(0, v)
    l.pop(0)

    l.popleft()
    l.appendleft()
    # 数据量大时，速度优于原生list
###### a Game:  
    import sys
    import time
    from collections import deque
    fancy_loading = deque('>--------------------')
    while True:
        print '\r%s' % ''.join(fancy_loading),
        fancy_loading.rotate(1)
        sys.stdout.flush()
        time.sleep(0.08)
        Result:
    # 一个无尽循环的跑马灯
#### Counter
    # 计数器
    from collections import Counter
    s = '''A Counter is a dict subclass for counting hashable objects. 
        It is an unordered collection where elements are stored as 
        dictionary keys and their counts are stored as dictionary values. 
        Counts are allowed to be any integer value including zero or 
        negative counts. The Counter class is similar to bags or multisets in other         
        languages.'''.lower()
    c = Counter(s)
    print c.most_common(5)
>[(' ', 54), ('e', 32), ('s', 25), ('a', 24), ('t', 24)]

#### OrderDict
    # 有序字典：记录了数据存入时的先后顺序
    # 不过发现一个骚操作：
#### defaultdict
    # 默认字典： 当key不存在时，返回此结果

---

## 线程
    创建线程： 使用Threading模块创建，从threading.Thread继承，然后重写__init__ 和run 方法
```python 
    import threading
    import time
 
    exitFlag = 0
 
    class myThread (threading.Thread):   #继承父类threading.Thread
        def __init__(self, threadID, name, counter):        
            threading.Thread.__init__(self)
            self.threadID = threadID
            self.name = name
            self.counter = counter
        def run(self):      
        #把要执行的代码写到run函数里面 线程在创建后会直接运行run函数 
            print "Starting " + self.name
            写到这儿
            print "Exiting " + self.name

    thread1 = myThread(1, "Thread - 1" , 1)
    thread1 = myThread(2, "Thread - 2" , 2)
    # 开启
    thread1.start()
    thread2.start()
```

### 线程同步    
不同线程对某个数据同时修改就很刺激，所以需要同步。（当然也可以选择不）
其实也简单，如下：
    
    import threading
    threadingLock = threading.Lock()
    # 从这儿领一把锁
    # 然后在 run()函数中，“写到这儿——也就是工作函数之前，写上
    threadingLock.acquire()
    # 随后在工作函数之后
    # threadingLock.release()

然后拿到小锁子的函数就能运行，运行完了把小锁子释放掉。为啥不是钥匙🔑……好吧。我就称呼它我就称呼它梭子吧——

## 队列
```md
    线程优先级队列
    Queue.qsize()	    返回队列的里站了几个
    Queue.empty()           如果队列为空，返回True,反之False
    Queue.full()            如果队列满了，返回True,反之False
    Queue.full 与 maxsize   大小对应
    Queue.get([block[, timeout]]) 
    	获取队列,timeout`等待时间
    
    Queue.get_nowait() 相当 
    Queue.get(False)
    
    Queue.put(item) 写入队列，timeout 等待时间
    
    Queue.put_nowait(item) 相当
    Queue.put(item, False)
    
    Queue.task_done()       在完成一项工作之后，
    Queue.task_done()       函数向任务已经完成的队列发送一个信号
    Queue.join()            实际上意味着等到队列为空，再执行别的操作
```

来段儿示例：来自[这儿](http://www.runoob.com/python/python-multithreading.html)
```python
    #!/usr/bin/python
    # -*- coding: UTF-8 -*-
 
    import Queue
    import threading
    import time
 
    exitFlag = 0
 
    class myThread (threading.Thread):
        def __init__(self, threadID, name, q):
            threading.Thread.__init__(self)
            self.threadID = threadID
            self.name = name
            self.q = q
        def run(self):
            print "Starting " + self.name
            process_data(self.name, self.q)
            print "Exiting " + self.name
    
    def process_data(threadName, q):
        while not exitFlag:
            queueLock.acquire()
            if not workQueue.empty():
                data = q.get()  
                queueLock.release()
                print "%s processing %s" % (threadName, data)   
            else:
                queueLock.release()
            time.sleep(1)
 
    threadList = ["Thread-1", "Thread-2", "Thread-3"]
    nameList = ["One", "Two", "Three", "Four", "Five"]
    queueLock = threading.Lock()
    workQueue = Queue.Queue(10)
    threads = []
    threadID = 1
 
    # 创建新线程
    for tName in threadList:
        thread = myThread(threadID, tName, workQueue)
        thread.start()
        threads.append(thread)
        threadID += 1
 
    # 填充队列
    queueLock.acquire()
    for word in nameList:
        workQueue.put(word)
    queueLock.release()
 
    # 等待队列清空
    while not workQueue.empty():    
        pass
 
    # 通知线程是时候退出
    exitFlag = 1
 
    # 等待所有线程完成
    for t in threads:
        t.join()
    print "Exiting Main Thread"
```

>Starting Thread-1

>Starting Thread-2

>Starting Thread-3

>Thread-1 processing One

>Thread-2 processing Two

>Thread-3 processing Three

>Thread-1 processing Four

>Thread-2 processing Five

>Exiting Thread-3

>Exiting Thread-1

>Exiting Thread-2

>Exiting Main Thread

呃， 以上就是我现知道的终极用法，当然其基础于：

    workQueue = Queue.Queue(10)     
    # 创建+设定队列长度（emm 小心卡死就是了）
    # 只要满了再往里塞绝对死，无意外……(lll￢ω￢)
    workQueue.put(word) 
    # 往里塞。  基础就是塞个数字，高级就是塞个线程
    workQueue.get() 
    # 顺序往外取
    # 括号里里面可以写进参数，然而，依然按照顺序往外取，插队办理啥的不存在
    # 另外，队列空的话取依然会死……

### 一些方法
```python
    q = queue.Queue(maxsize=0) 
    q.qsize() #查看队列大小 
    q.empty() #判断队列是否为空 
    q.full() 
    #如果maxsize设置了大小(eg:2)，如果q.put()了2个元素，则返回真，反之，则为假 
    q.get_nowait() 
    # 如果队列中没有元素了，只用q.get()
    （当然，可以设置`q.get(block=False）`）会使程序卡住，用q.get_nowait()则会报错而不卡住 
    q.put_nowait() 
    # 如果maxsize设置了大小，用q.put()超过范围则会卡住（当然
    # 可以设置属性q.put(block=False)）。用q.put_nowait()则会报错而不卡住
```
---

### 老夫的Demo

***消费生产者关系***
```python
import threading
import queue
import threadpool
import time

pool = threadpool.ThreadPool(2)

que = queue.Queue()

dataList = [1,2,3,4,5,6,7,8,9,0]
dataList1 = [1,2,3,'a', 'b']
dataList2 = [4,5,6]
dataList3 = [7,8,9,0]

printLock = threading.Lock()

workList = [dataList1, dataList2, dataList3]

def worker():    
   ## 消费者
   #printLock.acquire()
    aaa = que.get()
    print(aaa)
    for i in aaa:
        print (i)
    #printLock.release()
    time.sleep(5)

def geter(task):
    ## 生产者
    print("emm, put in_:", task)
    time.sleep(1)
    que.put(task)
    
    a = threading.Thread(target=worker)
    a.start()

for i in workList:
    geter(i)
```

---

---

## 进程
```python
import multiprocessing
import time
def worker_1(interval, lock, low):
    print ("worker_1")
    print (time.time())
    lock.acquire()
    time.sleep(0.1)
    print("I got the lock")
    time.sleep(interval)
    print(low)
    print ("end worker_1")
    lock.release()
def worker_2(interval, lock):
    print ("worker_2")
    print (time.time())   
    lock.acquire()
    print("I got the lock")
    time.sleep(interval)
    print ("end worker_2")
    lock.release()
def worker_3(interval, lock):
    print ("worker_3")
    print (time.time())
    lock.acquire()
    print("I got the lock")
    time.sleep(interval)
    print ("end worker_3")
    lock.release()
if __name__ == "__main__":
    printLock = multiprocessing.Lock()
    # 🔒 来自关爱的小锁子 
    p1 = multiprocessing.Process(target = worker_1, args = (2, printLock, ["asd", {'s':1}, [1,2,3]])).start()
    p2 = multiprocessing.Process(target = worker_2, args = (3, printLock)).start()
    p3 = multiprocessing.Process(target = worker_3, args = (4, printLock)).start()
    w = {'a':p1, 'b':p2, 'c':p3}
    # 创建三个进程去运行这三个函数
    #p1.start()
    #p2.start()
    #p3.start()
    #for i in w:
    #    w[i].start()
    # 启动进程

    print("The number of CPU is:" + str(multiprocessing.cpu_count()))   
    for p in multiprocessing.active_children():
        print("child   p.name:" + p.name + "\tp.id" + str(p.pid))
    print ("Main All Done")
    
    # dt 2018年5月18日11点22分
```
>worker_1
>1526613489.1864893
>worker_2
>1526613489.1932006
>The number of CPU is:4
>child   p.name:Process-3        p.id208
>child   p.name:Process-1        p.id206
>child   p.name:Process-2        p.id207
>Main All Done
>worker_3
>1526613489.1968668
>I got the lock
>['asd', {'s': 1}, [1, 2, 3]]
>end worker_1
>I got the lock
>
>end worker_2
>I got the lock
>end worker_3

<font color=ca5a00>插一句话</font>
线程和进程的关系，貌似与电脑双系统和系统再开虚拟机的关系emm  对于资源利用的角度上。

##### 没有传参的进程
```python 
import multiprocessing

def sayHello():
    print('hello~ I can see you')

if __name__ == '__main__':
    p1 = multiprocessing.Process(target=sayHello)
    p2 = multiprocessing.Process(target=sayHello)
    p3 = multiprocessing.Process(target=sayHello)
    p1.start()
    p2.start()
    p3.start()

```
如果只是单纯运行，这样就可以了，之所以做这个测试是因为我忌惮于那个`args`的传参，毕竟`()`里面若有元素存在就必须要有逗号…   看来没有传参的话就不需要了
一个参数`a`的时候: `(a, )`emmm🤔
### 将进程定义为类
    import multiprocessing
    import time
    class ClockProcess(multiprocessing.Process):
        def __init__(self, interval):
            multiprocessing.Process.__init__(self)
            self.interval = interval
        def run(self):
            n = 5
            while n > 0:
                print("the time is {0}".format(time.ctime()))
                time.sleep(self.interval)
                n -= 1 
    if __name__ == '__main__':
        p = ClockProcess(3)
        p.start()

<font color=red>以上，`p.start()`被调用时，自动调用`run()`   另外时间戳都是瞎戳的，所以… emm 这都一年之前的东西了，现在才想起来戳时间有点儿纪念意义(⊙﹏⊙) </font> 
>2018年5月18日
>
#### 属性
    daemon ：是否伴随主程序结束而结束
    Lock: 锁：（如下， 防止访问共享资源时冲突，如以上打印时间时出现的不连续打印😰）
    def worker(lock, var):
        try:
            ***
        finally:
            lock.release()
    lock = multiprocessing.Lock()
    var = '我是变量'
    p = multiptocessing.Process(target = worker, args = (lock, var))
    
    
## <font color=#cc0000>***警个告***</font>
创建进程分支的函数选择只能隶属于`__main__`下或者是隶属与创建进程的函数级别相同的级别，例如今天在main下一个函数中选择目标函数为此函数的函数就不可以… 如下：
```python 
    def a():
        def c(para):
            pass
    	*(target=b, args=(1,)) 	🌹
        *(target=c, args=(1,)) 	❌
    	
    def b(para):
        pass
```
emm，上述表述的很明确，但是昨天又重新犯了这个问题… 进程的执行者放到了类中的某个函数，然后又提出到`__main__
`中函数，所以都不能执行，最终放到`__main__``外，与它同级，也就是def 前无空格。 才能“受命”。

#### 通过队列来存储不同进程产生的结果
{来自}(https://blog.csdn.net/u014556057/article/details/66974452)
```
# -*- coding:utf-8 -*-
from multiprocessing import Process, Queue, Lock

L = [1, 2, 3]


def add(q, lock, a, b):
    lock.acquire()  # 加锁避免写入时出现不可预知的错误
    L1 = range(a, b)
    lock.release()
    q.put(L1)
    print L1

if __name__ == '__main__':
    q = Queue()
    lock = Lock()
    p1 = Process(target=add, args=(q, lock, 20, 30))
    p2 = Process(target=add, args=(q, lock, 30, 40))
    p1.start()
    p2.start()
    p1.join()
    p2.join()

    L += q.get() + q.get()
    print L

```
> [20, 21, 22, 23, 24, 25, 26, 27, 28, 29]
> [30, 31, 32, 33, 34, 35, 36, 37, 38, 39]
> [1, 2, 3, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39]


---

---

## 再加一个协程
### 基础实现：
```python 
# yield
def creatAor():
    mylist = range(3)
    for i in mylist:
        yield i*i

mygenerator = creatAor()  # 生成一个生成器
print (mygenerator)
for i in mygenerator:
    print (i)
```

> <generator object creatAor at 0x7f54ed368f10>
> 0
> 1
> 4

当调用函数时，其返回并不立马执行（显示）——emm 经过十几分钟😰的观察👀说那么玄乎，.其实就是在函数执行过程中，在`yield`处把后面紧接的东西记录下来，之后最后生成一个可迭代的对象。 所以网上说时生成器也不可厚非，但表达真的是……不过貌似.不仅仅是记录后面紧跟的东西…

```python
$ vim 
def creatAor():
    mylist = range(3)
    print("so jia nei?")
    for i in mylist:
        print("pre a hou ga")
        yield i*i
        print ("nihoua")
    print ("2333333")

mygenerator = creatAor()
print (mygenerator)
for i in mygenerator:
    print (i)
```

> <generator object creatAor at 0x7fe2585a8f10>
> so jia nei?
> pre a hou ga
> 0
> nihoua
> pre a hou ga
> 1
> nihoua
> pre a hou ga
> 4
> nihoua
> 2333333

所以看这苗头像是重新执行了一次函数，但是将后面紧跟的东西也进行了记录

应用到协程中，便是：

```python 
import time

def consumer():
    r = ''
    while True:
        n = yield r
        if not n:
            return
        print('[CONSUMER] Consuming %s....' % n)
        time.sleep(1)
        r = '200 OK'

def produce(c):
    c.next()
    n = 0
    while n < 5:
        n = n + 1
        print('[PRODUCER] Producing %s...' % n)
        r = c.send(n)
        print('[PRODUCER] Consumer return: %s\n' % r)
    c.close()

if __name__=='__main__':
    c = consumer()
    produce(c)
    for i in c:
        print(i)
```

> [PRODUCER] Producing 1...
> [CONSUMER] Consuming 1....
> [PRODUCER] Consumer return: 200 OK
> 
> [PRODUCER] Producing 2...
> [CONSUMER] Consuming 2....
> [PRODUCER] Consumer return: 200 OK
> 
> [PRODUCER] Producing 3...
> [CONSUMER] Consuming 3....
> [PRODUCER] Consumer return: 200 OK
> ...
> ...


那么，是什么道理呢？
#### send next 方法的背后今生
```python
def my():
    value = yield 1
    value = yield value
    print('finally: ', value)
ge = my()
print(ge.next())
print(ge.send(2))
print(ge.send(3))
```

> 1
> 2
> ('finally: ', 3)
> Traceback (most recent call last):
>   File "yield_emm3.py", line 8, in <module>
>     print(ge.send(3))
> StopIteration


可知：
 当`next`时，`yield`挂起，但将之后的`1`返回。而后`send`激活了之前挂起赋值动作，但此时`yield 1`被替换为`send`来的`2`所以`value`被置为`2`. 再第三次调用，完成赋值动作之后，由于只被挂起两次动作，而这里调取了三次，所以报错 停止递归 。若直接递归则得到1 和 None.   

所以 `next`与`send`都是用来激活挂起动作而使用的，但`send`好在可以与之交互。
<font color=red>在`send``之前需先`next`否则提示`can't send * to a just-started generator`</font>(⊙﹏⊙)  我上面阐述的挂起，激活，是不是出现了什么偏差…
> 2018年5月18日16点30分

### 较完善方案：

```python 
# 1
import gevent
def f(n):
    for i in range(n):
       print gevent.getcurrent(), i

g2 = gevent.spawn(f, 5)
g3 = gevent.spawn(f, 5)

g1.join()
g3.join()

# 2
import gevent
from gevent import monkey; monkey.patch_all()
import urllib2

def f(url):
    print 'GET: %s' % url
    resp = urllib2.urlopen(url)
    data = resp.read()
    print '[%d] bytes received from %s\n' %(len(data), url)
    
gevent.joinall([
    gevent.spawn(f, 'http://www.cnblogs.com/kaituorensheng/'),
    gevent.spawn(f, 'https://www.python.org/'),
    gevent.spawn(f, 'https://www.baidu.com'),
])

# 3
from gevent import monkey  
monkey.patch_all()  
import gevent  
from gevent import Greenlet  
  
class Task(Greenlet):  
    def __init__(self, name):  
        Greenlet.__init__(self)  
        self.name = name      
    def _run(self):  
        print "Task %s: some task..." % self.name  
  
t1 = Task("task1")  
t2 = Task("task2")  
t1.start()  
t2.start()  
# here we are waiting all tasks  
gevent.joinall([t1,t2])  
```

和线程 进程 差不多一个用法，只不过没锁，也不需要锁。



---

---

---

### futures
####  futures.ThreadPoolExecutor
```py
with futures.ThreadPoolExecutor(16) as executor:
    executor.map(run, urls)
    # 这里是个爬虫，urls就是一个前方run函数的输入变量
```

---

---

---

## 父类中的变量与类中变量
在使用`self.a` 的时候——呃其实是实例化之后a.a时，会只在父类中寻找相关变量，而解决办法居然是将`super(A, self).__init__(CtaEngine, setting)`移动到变量定义之后，所以谁说这玩意放前面和放后面没有区别的！（欸?😘 这个之后有过说明，不过忘记写在哪儿了，再说一下，就是super....表示父类的初始化动作，__init__因为这个函数名子父相同不会重写，会合并。）

### 列表的增删添
    append      # 在最后添加一元素
    extend      # c.extend(a) 将列表a中元素加到c中去。可自加
    +           # 连接两方数组元素 c = a + c        然而创建新对象，耗内存… 所以没啥
用
    
    del         # 删除对应下标元素 del c[0] 删除c列表第一位元素
    pop         # c.pop()   删除最后一位元素
    remove      # 删除指定值元素，有相同值时只会删除第一位
    [ : ]           # 使用切片进行删除
    insert      # c.insert(0, 1)将1插入到c的最前方，可插列表，插入还是列表


### 一个函数的有效方式只在循环中执行一次 - 代码日志
[这](https://codeday.me/bug/20170901/65228.html)是原链接
emm 代码反正照着输入是不会有结果的，但感觉挺有戏先保留，以后技术提升再来看
#### 自己的方法
自己的方法很简单，很暴力，就是用字典啊—— 当执行过一次之后直接把调用关系扭到别的地方，反正只要是知道结果的判断都可以用字典来代替么。

### 函数调用函数 and 语法糖 @
    import time
 
    def timehel(hell):
        def wrapper():
                start = time.clock()
                hell()
                end =time.clock()
                print 'used:', end - start
            return wrapper

@timehel
def foo():
    print 'a ho ga'
>a ho ga

>used:  0.000489465229975

其上@timehel 和 foo = timehel(foo)等价（感谢[被遗忘的博客](http://www.cnblogs.com/rollenholt/archive/2012/05/02/2479833.html)）… 就是把下方函数当成输入，然后执行通俗来翻译就是： 

    @：呼叫timehel   来执行下面这孙子。
    
这里是官方教你怎么用： 
    <https://wiki.python.org/moin/PythonDecoratorLibrary>

其中 函数中定义函数就类似于“父子关系”，也或者叫另辟空间。每次执行父函数时，子函数会有也尽在此时会有被执行的机会，会不会被执行，就看其在其父亲面前的表现了（他爸有没有叫他（有没有调用…））。

### 变量作用域
因为从这个@ 这儿学到的，所以：

    def hel(x):
        def inner():
            print x
        return inner
    p1 = hel(1)
    p1 = hel(1)

    p1()
>1

    p2()
>2

闭包——如果没有inner这东西，下面绝不会输出东西，反而会报错。 直接`p1`,`p2`又不会再输出任何东西，只有在定义时会运行一次。 对比于`def hel(x):   print x`    其中内层原因 先不深究，就脑补成外层需运行时才能去找那些变量，而其中的函数会主动去外围找所需的变量。
#### 应用案例
    import time

    def coseTime(func):
        print func
        def inner(*args, **kwargs):
            print args, kwargs
            start = time.clock()
            func(*args, **kwargs)
            end = time.clock()
            print args, kwargs
    
            print ('Running time: %s Seconds' % (end-start))
        return inner

    @coseTime
    def hel(x):
        print ('hello~')

    hel(12)
><function hel at 0x02BC5070>
>(12,) {}
>hello~
>(12,) {}
>Running time: 0.000446197317167 Seconds

用来无视变量来记录 函数运行所需时间的——同时输出其在运行时接入的变量


---

---

## functools
就姑且放这儿吧，毕竟也算是为了有序执行而接触到的

### partial
    import functools
    def add(a, b):
        print a, b
        return a, b
    addplus = functools.partial(add, 3)
    addplus(7)
>3   7

    addplus(add, b = 6)
    addplus(7)
>7   6

这函数作用是 提前给定函数一个变量值…The functools module is for higher-order functions: functions that act on or return other functions. In general, any callable object can be treated as a function for the purposes of this module. 

我的接触场景是在PyQt 中信号槽循环连接时，用了partial在connect之后`.connect(partial(self.start, i))`去唯一化相同功能的复用。不过我之前也应该写过类似的，那时我找的解决办法时在连接调用时传参(在Python GUI里面应该会写有吧，假如两三个月前我没脑子短期性失忆的话😭)。emm那个传参是利用Qt机制 不知道孰优孰劣😄 

    运气好，直接翻到：
        ——那里的应用场景是在鼠标点击按钮捕获点击事件click时传递的参数~
# lambda
使用方法为：

    func = lambda x:x*x
    # :前x表示函数输入，:后为返回值，x*x是这个函数收到输入后所执行的动作
    w = lambda x:func(x)
    
---

---

---

---

---

# 网络编程
## socket
    import socket
    # 服务端
    s = socket.socket()
    host = socket.gethostname()
    port = 12345
    s.bind((host, port))
    s.listen(5)
    while True:
        c, addr = s.accept()
        print "link address is", addr
        c.send('welcome here')
        c.close()
    # 客户端
    s = socket.socket()
    host = socket.gethostname()
    port = 12345
    s.connect((host, port))
    # 此时服务端便弹出 link address is：('192.168.*.*', 64*5)
    print s.recv(1024)
    # 客户端显示welcome here

## select :   与Socket配合的跨平台的异步io模型

import select
import socket
import Queue

#create a socket
server = socket.socket(socket.AF_INET,socket.SOCK_STREAM)
server.setblocking(False)
#set option reused
server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR  , 1)

server_address= ('192.168.1.102',10001)
server.bind(server_address)

server.listen(10)

#sockets from which we except to read
inputs = [server]

#sockets from which we expect to write
outputs = []

#Outgoing message queues (socket:Queue)
message_queues = {}

#A optional parameter for select is TIMEOUT
timeout = 20

while inputs:
    print "waiting for next event"
    readable , writable , exceptional = select.select(inputs, outputs, inputs, timeout)

    # When timeout reached , select return three empty lists
    if not (readable or writable or exceptional) :
        print "Time out ! "
        break;    
    for s in readable :
        if s is server:
            # A "readable" socket is ready to accept a connection
            connection, client_address = s.accept()
            print "    connection from ", client_address
            connection.setblocking(0)
            inputs.append(connection)
            message_queues[connection] = Queue.Queue()
        else:
            data = s.recv(1024)
            if data :
                print " received " , data , "from ",s.getpeername()
                message_queues[s].put(data)
                # Add output channel for response    
                if s not in outputs:
                    outputs.append(s)
            else:
                #Interpret empty result as closed connection
                print "  closing", client_address
                if s in outputs :
                    outputs.remove(s)
                inputs.remove(s)
                s.close()
                #remove message queue 
                del message_queues[s]
    for s in writable:
        try:
            next_msg = message_queues[s].get_nowait()
        except Queue.Empty:
            print " " , s.getpeername() , 'queue empty'
            outputs.remove(s)
        else:
            print " sending " , next_msg , " to ", s.getpeername()
            s.send(next_msg)
    
    for s in exceptional:
        print " exception condition on ", s.getpeername()
        #stop listening for input on the connection
        inputs.remove(s)
        if s in outputs:
            outputs.remove(s)
        s.close()
        #Remove message queue
        del message_queues[s]
[糖拌咸鱼 - 记录学习的点点滴滴~](http://www.cnblogs.com/coser/archive/2012/01/06/2315216.html)

简单来说一下`select`的作用：
    返回值：三个列表
    select方法用来监视文件描述符(当文件描述符条件不满足时，select会阻塞)，当某个文件描述符状态改变后，会返回三个列表
        1、当参数1 序列中的fd满足“可读”条件时，则获取发生变化的fd并添加到fd_r_list中
        2、当参数2 序列中含有fd时，则将该序列中所有的fd添加到 fd_w_list中
        3、当参数3 序列中的fd发生错误时，则将该发生错误的fd添加到 fd_e_list中
        4、当超时时间为空，则select会一直阻塞，直到监听的句柄发生变化
       当超时时间 ＝ n(正整数)时，那么如果监听的句柄均无任何变化，则select会阻塞n秒，之后返回三个空列表，如果监听的句柄有变化，则直接执行。
    `epoll`很好的改进了`select` 具体请看(深入理解python中的select模块)[http://blog.csdn.net/songfreeman/article/details/51179213]

---

---

---

## 引用模块
action.py中引用model.py为例
### 同一文件夹下
    from model import *
    # or
    import model
### 其下级文件"here"下
    # 在model.py 文件中创建__init__.py空文件
    from here import model
    # or
    form here.model import *
### 在上级文件下
    import sys
    sys.path.append("..")
    # 添加上级文件 路径
    # import model
### 在上级文件的下级文件中（也就是在隔壁“wang”文件中）
    # 需要创建__init__.py空文件
    # 添加上级文件路径
    import wang.model


## 解决编码问题
    import sys
    reload(sys) 
    sys.setdefaultencoding('utf8')
    # 这段直接塞它嘴里

### 输出提示打印乱码
    #coding: utf-8  
    n=raw_input(unicode('请输入文字','utf-8').encode('gbk'))  
    print n  

### 内存异常占用
    import sys
    v = 1
    sys.getsizeof(v)
    # 可以读出 此变量emm 或者说 对象的内存占用大小

## 异常
### plan1 ：
    try:
    #正常的操作
    except:
    #发生异常，执行这块代码
    else:
    #如果没有异常执行这块代码(在执行完try下函数没有异常发生)
### 列表的坑
当a 为一个列表
    a = [1, 2, 3]
    b = a 
    c = a
    d = a
    b.append(4)

这时，abcd四个列表都变成[1, 2, 3, 4]，emm…  所以直接以后不要把一个列表赋值给两个变量…除非不涉及修改，慎重慎重。。不过python中列表有`copy`一说，不过还没试过

### \@staticmethod
    定义类中的的这个方法为静态方法，同理的还有`@classmethod`类方法。
### 常见异常
    1.AssertionError：当assert断言条件为假的时候抛出的异常
    2.AttributeError：当访问的对象属性不存在的时候抛出的异常
    3.IndexError：超出对象索引的范围时抛出的异常
    4.KeyError：在字典中查找一个不存在的key抛出的异常
    5.NameError：访问一个不存在的变量时抛出的异常
    6.OSError：操作系统产生的异常
    7.SyntaxError：语法错误时会抛出此异常
    8.TypeError：类型错误，通常是不通类型之间的操作会出现此异常
    9.ZeroDivisionError：进行数学运算时除数为0时会出现此异常··

---

---

---

# 事件模式中，事件篡改事故
在循环创建事件时，将`event` `put`到队列中，此时，被处理一半，因为不在一个线程所以下一个循环来临就将`event`的内容进行了修改。 杜绝此方法除了添加锁，只好将事件`copy`之后再传入时间引擎。如此便可暂防止事件处理一半被修改的事情发生。 

---

---

---

# 代码块注释
[Surrounding Blocks of Code with Language Constructs](https://www.jetbrains.com/help/pycharm/surrounding-blocks-of-code-with-language-constructs.html)
### VisualStudio模式：
    #region Description(说明)
    print "code here"
    #endregion
### NetBeans模式：
    // <editor-fold desc="Description">
    code here
    // </editor-fold>

# 类
    以后详谈，本着一切皆对象的原则，所以对于类的了解决定了Python的认知，先记一个
    def __init__(self):
            super(Proformance, self).__init__()
    #这个super表示了继承类和被继承类的 __init__调用时序，其它重名函数是覆盖，这个……
## 数据类
用一个类来表示一个数据类型（这几天想着这个表示不同数据类型的组合方法恰类似于C中的结构体，然后`Python`中的数组元素存储各种东西什么类啊、数组套数组啊，字典存储啊，恰巧与C中的指针指向指针……emm ）如：
    
    class A(object):
        def __init__(self):
        self.a = 'a'
        self.b = 'b'
    A().__dict__
>{'a': 'a', 'b': 'b'}

但是`A().__dict__['a'] = 'It is a'` 虽然不会报错，但之后再次调用`A().__dict__`显示结果还是一样，但：

    a = A()
    a.__dict__['a'] = 'It is a'
    a.__dict__
>{'a': 'It is a', 'b': 'b'} 

这样我就用过一次，在不确定数据类会有几个元素甚至不知道会是什么名称的时候来创建的，毕竟：(这样的方式可以随便添加嘛)

    a.__dict__['w'] = 'It is www'
    a.__dict__
>{'a': 'It is a', 'b': 'b', 'w': 'It is www'

### 若出现docx模块pyInstaller打包问题
大概的解决步骤是这样的：
找到python-docx包安装路径下的一个名为default.docx的文件，我是通过everything这个强大的搜索工具全局搜索找到这个文件的，它在我本地所在的路径是：E:\code\env\.env\Lib\site-packages\docx\templates 
把找到的default.docx文件复制到我的py脚本文件所在的目录下。
修改脚本中创建Document对象的方式：
从原来的创建方式：
document = Document()
修改为：
import os
document = Document(docx=os.path.join(os.getcwd(), 'default.docx'))
再次用pyinstaller工具打包脚本为exe文件
把default.docx文件复制到与生成的exe文件相同的路径下，再次运行exe文件，顺利运行通过，没有再出现之前的报错，问题得到解决。
作者：(m2fox)[https://www.jianshu.com/p/94ac13f6633e]
來源：简书

#### 拼接List字符串
将list中的元素拼接起来，并使用`,`隔开可这么来：
    
    import itertools 
    list = ['123', '567']
    xlist = ",".join(list)
    or
    ylist = ",".join(*list)
    s = .join(itertools.chain(kwargs.keys()))
    
区别在于x为一个元素添加一个`,`，y为把列表中的素也拆分之后再添加

### SimpleHTTPServer
小型的局域网嘛☺，很常用，不过在Python3中有了变化…
```py
    $ Python2
    python -m SimpleHTTPServer 
    ---
    $ Python3
    python -m http.server
```
<font color=#126590>顺带一提</font>：`-m`是可以在外执行内库的操作，🦑大概是这个意思吧—— 用`pdb`的时候也是这么用的…

### 老夫的月份生成
```python 
# -*- coding:utf-8 -*-
import datetime
import copy

def splitMonth(start, end):
    start = str2Date(start)
    end = str2Date(end)
    _delta = end - start
    datelist = []
    if _delta.days > 10:
        # 拆分
        # 按*月*拆分（10日间隔）
        n = 0
        _start = copy.copy(start)
        while _delta.days > 0:
            n += 1
            if _start.day < 10:
                _end = datetime.date(_start.year, _start.month, 10)
                if end > _end:
                    datelist.append((date2str(_start), date2str(_end)))
                    _start = _end + datetime.timedelta(1)
                else:
                    datelist.append((date2str(_start), date2str(end)))
                    break
            elif _start.day < 20:
                _end = datetime.date(_start.year, _start.month, 20)
                if end > _end:
                    datelist.append((date2str(_start), date2str(_end)))
                    _start = _end + datetime.timedelta(1)
                else:
                    datelist.append((date2str(_start), date2str(end)))
                    break
            else:
                _end = datetime.date(_start.year, _start.month, _start.day) + datetime.timedelta(15)
                _end = datetime.date(_end.year, _end.month, 1) - datetime.timedelta(1)
                if end > _end:
                    datelist.append((date2str(_start), date2str(_end)))
                    _start = _end + datetime.timedelta(1)
                else:
                    datelist.append(date2str(_start), date2str(end))
                    break

            _delta = end - _start + datetime.timedelta(1)

        return datelist
    else:
        return [(date2str(start), date2str(end))]
def splitMouthBySE_N(start, end, n):
    start = str2Date(start)
    end = str2Date(end)
    _delta = end - start
    datelist = []
    if _delta.days > n:
        # 拆分
        # 按*月*拆分（10日间隔）
        _start = copy.copy(start)
        while _delta.days > 0:
            _loop = 0
            for _n in range(int(30/n)):
                _loop = _loop + n
                if _start.day < _loop:
                    if _start.month == 2 and _loop > 28:
                        if _start.year%4:
                            _end = datetime.date(_start.year, _start.month, 28)
                        else:
                            _end = datetime.date(_start.year, _start.month, 29)
                    else:
                        _end = datetime.date(_start.year, _start.month, _loop)
                    if end > _end:
                        datelist.append((date2str(_start), date2str(_end)))
                        _start = _end + datetime.timedelta(1)
                    else:
                        datelist.append((date2str(_start), date2str(end)))
                        _delta = datetime.timedelta(0)
                        break
                    _end = datetime.date(_start.year, _start.month, _start.day) + datetime.timedelta(15)
                else:
                    continue
            else:
                _end = datetime.date(_end.year, _end.month, 1) - datetime.timedelta(1)
                if end > _end:
                    if _start > _end:
                        _delta = end - _start + datetime.timedelta(1)
                    else:
                        datelist.append((date2str(_start), date2str(_end)))
                    _start = _end + datetime.timedelta(1)
                else:
                    datelist.append((date2str(_start), date2str(end)))
                    _delta = datetime.timedelta(0)
                    break

                _delta = end - _start + datetime.timedelta(1)

        return datelist
    else:
        return [(date2str(start), date2str(end))]
def gropdate(datelist, itemNum=0, gropNum=0):
    #将传入datelist[(str(start1), str(end1)), (str(start2), str(end2))...] -> 传入为月碎片
    # 打按月对月碎片进行打组。 
    # 传入参数 itemNum: 一个组含几个月, gropNum: 将这些碎片打为几组
    _dic = collections.OrderedDict()
    for i in datelist:
        # 按月分组
        keyName = i[0].split('-')[1]
        if keyName not in _dic:
            _dic[keyName] = []
        _dic[keyName].append(i)
    monthList = []
    groups = []
    groupListTemp = []
    groupList = []
    for i in _dic.keys():
        # 得到月份列表
        monthList.append(i) #[1,2,3...,7,8,9]
    monthNum = len(monthList)

    if gropNum:
        itemNum = round(float(monthNum)/gropNum)
        itemNum = int(itemNum)
    if itemNum:
        slipNum = int(monthNum/itemNum)
        start = 0
        end = int(itemNum)
        for mon in range(slipNum):
            groups.append(monthList[int(start):int(end)])
            start = copy.copy(end)
            end = end + itemNum
        if monthNum%itemNum:
            groups.append(monthList[start:monthNum])    # 非整除补足
        for i in groups:
            for ii in i:
                groupListTemp.append(_dic[ii])
            groupList.append(groupListTemp)
            groupListTemp = []
        return groupList
    else:
        return None
        
# region 日期`date`格式与`str`转换处理
def date2str(_date):
    # datetime.date 转换为 str    (有为了适配原程序的补零操作…)
    if _date.month < 10:
        strDate = str(_date.year) + '-' + '0'+str(_date.month) + '-' + str(_date.day)
    else:
        strDate = str(_date.year) + '-' + str(_date.month) + '-' + str(_date.day)
    if _date.day < 10:
        strDate = strDate[:-1] + '0'+str(_date.day)
    return strDate
def str2Date(_str):
    # str 转换为 datetime.date
    y, m, d = _str.split('-')
    return datetime.date(int(y), int(m), int(d))

# endregion 


if __name__ == '__main__':
    print(splitMouthBySE_N('2016-01-02', '2018-03-01', 5))
```

## Python3.6之后的奇淫技巧
1. 可使用下划线将长数字隔开，便于阅读  `10000`=`10_000`
2. 字符串操作除了 `%`和`format`之外还有`f`操作
```python
$ %
s = "%s is %d" % ('two', 2)
$ format
s = "{fruit} is {color}".format(fruit='apple', color='red')
$ f
name = 'Bob'
f'Hello, {name}!'
### 甚至
a = 5
b = 10
f'Five plus ten is {a + b} and not {2 * (a + b)}.'
#### 精度
PI = 3.141592653
f"Pi is {PI:.2f}"
>>> 'Pi is 3.14'
>>> error = 50159747054
##### 以16进制格式化
f'Programmer Error: {error:#x}'
>>>'Programmer Error: 0xbadc0ffee'

##### 以二进制格式化
f'Programmer Error: {error:#b}'
>>> 'Programmer Error: 0b101110101101110000001111111111101110'
```
3.变量注释 `def my_add(a: int, b: int) -> int:   \n  return 0` 仅仅用来注释，其实传参出参<font color=#9aaa00>并不受控制…</font>

---

# 魔法方法
假设定义类  `EmmNe`, `EmmNe`拥有`self.aaa`与`self.aaadict`、列表`self.aaalist` 且`__init__`允许两个传参

<font color=#feaaaa>\_\_len\_\_</font>:
```python
def __len__(self):
    return len(self.aaa)
# 则在外`len`此实例化对象时，会返回这个结果
```
<font color=#feaaaa>\_\_getitem\_\_</font>:
```python
def __getitem__(self, key)
    return self.aaadict[key]
en = EmmNe(1, 2)
print(en[`])
> 2
#就像上面那样。 不过还有下面的用法
def __getitem__(self, index):
    retrun self.aaalist[index]
w = Emm(1,2)
for i in w:
    print (i)
# 则输出列表中内容
```
<font color=#feaaaa>\_\_setitem\_\_</font>:
```python
def __setitem__(self, key, value)
    return self.aaadict[key] = value
# 拥有此方法，则在外可将实例对象当作字典操作:
enp['a'] = 'asd'
# 就像这样

```
### collectionss
总结一句话： `collections`出品， 必属精品。
马上能想到的 有序字典，还有那啥都是出自此个模块之下。
今天用的 计数也是出自此处      反正之后 这个里面能实现的功能，那就放弃手写吧————😓
from collections import Counter

### Function Annotations
Annotations are stored in the __annotations__ attribute of the function as a dictionary and have no effect on any other part of the function. Parameter annotations are defined by a colon after the parameter name, followed by an expression evaluating to the value of the annotation. Return annotations are defined by a literal ->, followed by an expression, between the parameter list and the colon denoting the end of the def statement. The following example has a positional argument, a keyword argument, and the return value annotated:
```python 
>>>
def f(ham: str, eggs: str = 'eggs') -> str:
    print("Annotations:", f.__annotations__)
    print("Arguments:", ham, eggs)
    return ham + ' and ' + eggs

f('spam')

>>> Annotations: {'ham': <class 'str'>, 'return': <class 'str'>, 'eggs': <class 'str'>}
>>> Arguments: spam eggs
>>> 'spam and eggs'
```
### Logger
模块名： logging
上手容易，功能丰富，性能肯定也好过自己✍
另外，懒———
```
import sys
import logging
import logging_error

logger1 = logging.getLogger('loger1')
logger2 = logging.getLogger('loger2')
#实例化两个logger,默认名称为：`root`
"""
我居然以为root是程序执行处的名字，以为放到函数中就会显示函数名。emm
所以才有了下面多层函数嵌套…，以及调用外部`import`
"""

formatter = logging.Formatter('[%(name)s]%(asctime)s %(levelname)-8s: %(message)s')
#定义日志格式：
"""
%(name)s Logger的名字
%(levelno)s 数字形式的日志级别
%(levelname)s 文本形式的日志级别
%(pathname)s 调用日志输出函数的模块的完整路径名，可能没有
%(filename)s 调用日志输出函数的模块的文件名
%(module)s 调用日志输出函数的模块名|
%(funcName)s 调用日志输出函数的函数名|
%(lineno)d 调用日志输出函数的语句所在的代码行
%(created)f 当前时间，用UNIX标准的表示时间的浮点数表示|
%(relativeCreated)d 输出日志信息时的，自Logger创建以来的毫秒数|
%(asctime)s 字符串形式的当前时间。默认格式是“2003-07-08 16:49:45,896”。逗号后面的是毫秒
%(thread)d 线程ID。可能没有
%(threadName)s 线程名。可能没有
%(process)d 进程ID。可能没有
%(message)s 用户输出的消息
"""

fileHandler = logging.FileHandler('loger.log')
fileHandler.setFormatter(formatter)

consoleHandler = logging.StreamHandler(sys.stdout)
consoleHandler.formatter = formatter
#配置文件、终端日志处理器。可以使用不同格式，来区分处理

logger1.addHandler(fileHandler)
logger2.addHandler(fileHandler)
logger1.addHandler(consoleHandler)
logger2.addHandler(consoleHandler)
#为日志机添加处理器

logger1.setLevel(logging.INFO)
#logger2.setLevel()
#设置各日志机打印等级


logger1.debug('debugO')
logger1.info('info')
logger2.info('info')
logger1.error('error')
def warn_msg():
    logger1.warn('warn msg')
    warn_msg2()
def warn_msg2():
    logger2.warn(u'warn 信息')
    logging_error.error_demo()
warn_msg()
```
当然，logger还有别的调用方法，不过这应该就够了，
具体要怎么实现，就去找官方文档了。
预防针： 多种配置方法、日志重复输出:[见此](http://python.jobbole.com/86887/)

## lambda函数
### 排序
```py
aaa
>>> [{'time': 1}, {'time': 3}, {'time': 2}]
sorted(aaa, key = lambda x: x["time"])
>>> [{'time': 1}, {'time': 2}, {'time': 3}]
sorted(aaa, key = lambda x: x["time"], reverse=True)
>>> [{'time': 3}, {'time': 2}, {'time': 1}]
```

## Mock 
使用: unittest
```python
    mock.patch.object: Mock # 一个类, 后接方法
    mock.patch: Mock # 一个方法, 按路径

    @mock.patch("databases.wx_service.get_user_base_info")
    @mock.patch.object(wx_service.WeChat_OAP, "send_template_msg")
    def test_create_weawarning(self, mock_send_template_msg, mock_get_user_base_info):
        # 装饰器生效从内到外, 传入参数顺序, 从左到右
        pass
        mock_send_template_msg.return_value = ''/{}/[]/() 皆可  设定mock返回值
        mock_get_user_base_info.side_effect = [''/{}/[]/(), ''/{}/[]/()] 设定每次调用mock函数依次返回返回值
```

