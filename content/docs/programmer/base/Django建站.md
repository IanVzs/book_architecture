---
title: Django的建站的(｡･･)ﾉﾞ
date: 2018-06-07 16:30:18
modified: 2018-05-28 17:30
category: [web, 全栈笔记]
tags: [django, missjava, vue, apache, ajax]
slug: notesDjango
---
author: Ian

# Django 的一些东西
![http server/client](http://lofrev.net/wp-content/photos/2017/04/http_logo_dpwnload.png)
## 一些问题
### 使用字体 `zh-cn`时如果报错: 
>OSError: No translation files found for default language zh-cn.

```python
LANGUAGE_CODE = 'zh-Hans'
TIME_ZONE = 'Asia/Shanghai'
# zh-Hans是简体中文 zh-Hant是繁体中文

# 如果数据库有UTC的时间，那么可以设置：
# USE_TZ = True 改为
USE_TZ = False
```
### 时区问题
>python3.8/site-packages/django/db/models/fields/__init__.py:1416: RuntimeWarning: DateTimeField {DATABASEMODEL}.update_time received a naive datetime (2023-09-14 21:55:56) while time zone support is active.
  warnings.warn("DateTimeField %s received a naive datetime (%s)"

这个警告是由于在使用带有时区支持的DateTimeField字段时，传入了一个没有时区信息的datetime对象。要修复这个警告，你可以将传入DateTimeField字段的datetime对象转换为带有时区信息的datetime对象。

有两种方法可以解决这个问题：

1. 使用带有时区信息的datetime对象：确保在创建datetime对象时，使用正确的时区信息。你可以使用`pytz`库来设置时区信息，例如：
```python
from datetime import datetime
import pytz

# 创建带有时区信息的datetime对象
naive_datetime = datetime(2023, 9, 14, 21, 55, 56)
timezone = pytz.timezone("Asia/Shanghai")
aware_datetime = timezone.localize(naive_datetime)

# 将带有时区信息的datetime对象传递给DateTimeField字段
ScannerDevice.update_time = aware_datetime
```
2. 将DateTimeField字段的`auto_now`或`auto_now_add`属性设置为`True`：这将自动将字段的值设置为当前的带有时区信息的datetime对象。例如：
```python
from django.db import models

class DATABASEMODEL(models.Model):
    update_time = models.DateTimeField(auto_now=True)
```
通过以上两种方法之一，你可以修复这个警告并确保正确处理时区信息。
## daemon 命令
> Django 的 BaseCommand怎么使用？

**AI:**
要使用 Django 的 BaseCommand，你需要按照以下步骤操作：
1. 创建一个新的 Python 模块或文件，例如 `myapp/management/commands/mycommand.py` **这里的路径很重要**
2. 在 `mycommand.py` 文件中导入必要的模块和类：
```python
from django.core.management.base import BaseCommand
```
3. 创建一个继承自 `BaseCommand` 的子类，并实现 `handle()` 方法来定义你的命令逻辑。例如：

```python
class Command(BaseCommand):
    help = 'My custom command'

    def handle(self, *args, **options):
        # 在这里编写你的命令逻辑
        self.stdout.write('Hello, world!')
```

4. 在 Django 项目中运行你的命令。使用以下命令格式：

```bash
python manage.py mycommand
```

这将执行你在 `handle()` 方法中定义的逻辑。
你还可以在 `handle()` 方法中使用 `self.stdout.write()` 方法来输出信息到命令行。
### 示例如下:

```python
from django.core.management.base import BaseCommand

class Command(BaseCommand):
    def add_arguments(self, parser):
        parser.add_argument('-s', "--start", required=True)
        parser.add_argument('-e', "--end", required=True)
  
    def handle(self, **options):
        try:
            start_timed = datetime.datetime.strptime(options.get('start', None), "%Y-%m-%d")
            end_timed = datetime.datetime.strptime(options.get('end', None), "%Y-%m-%d")
            run(start_timed, end_timed)
        except Exception:
            print(traceback.print_exc())
```

如此就可以使用如下命令执行:
```bash
python manage.py {pyfilename} --start 2023-04-01 --end 2023-05-01
````
## 利用nginxfd反向代理解决跨域问题
纠结了很久的跨域问题。。。。。。一直配置Django。。。。。问题重重，从配置方面这条路还没找到解决方案，如以后确认无误后就再放在这儿。告慰前面付出的种种艰辛 😓😀

来自(这儿)[https://www.jb51.net/article/105786.htm]

方法是： 打开`nginx`默认配置文件`/etc/nginx/sites-available/default`
更改如下：
```
## demo listen 5017 proxy 5000 and 5001 ##
server {
 listen 5017; 
 server_name a.xxx.com;
 access_log /var/log/nginx/a.access.log;
 error_log /var/log/nginx/a.error.log;
 root html;
 index index.html index.htm index.php;
 ## send request back to flask ##
 location / {
  proxy_pass http://127.0.0.1:5000/ ; 
 #Proxy Settings
  proxy_redirect off;
  proxy_set_header Host $host;
  proxy_set_header X-Real-IP $remote_addr;
  proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  proxy_next_upstream error timeout invalid_header http_500 http_502 http_503 http_504;
  proxy_max_temp_file_size 0;
  proxy_connect_timeout 90;
  proxy_send_timeout 90;
  proxy_read_timeout 90;
  proxy_buffer_size 4k;
  proxy_buffers 4 32k;
  proxy_busy_buffers_size 64k;
 }
 location /proxy {
  rewrite ^.+proxy/?(.*)$ /$1 break;
  proxy_pass http://127.0.0.1:5001/ ; 
 #Proxy Settings
  proxy_redirect off;
  proxy_set_header Host $host;
  proxy_set_header X-Real-IP $remote_addr;
  proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  proxy_next_upstream error timeout invalid_header http_500 http_502 http_503 http_504;
  proxy_max_temp_file_size 0;
  proxy_connect_timeout 90;
  proxy_send_timeout 90;
  proxy_read_timeout 90;
  proxy_buffer_size 4k;
  proxy_buffers 4 32k;
  proxy_busy_buffers_size 64k;
 }
}
## End a.xxx.com ##
```
很显然，这种解决方法仅仅适用于同服务器，架设两个网站。进行跨域访问。
所以这种东西……就很欠缺。  或者`nginx`也支持多服务器“并联”？ 

但这种解决方案依然不能解决两个“严格无关”的网站通信。 

##### 摒弃`java`后的'欢乐'?时光?
## Django 的前端相关
[^_^]虽然我前端不用这个吧，但就一记录。届时估计还是回来翻Django官方文档的。
摘一个看一个牛逼哄哄的东西：
Removing hardcoded URLs in templates
Remember, when we wrote the link to a question in the polls/index.html template, the link was partially hardcoded like this
```html
    <li><a href="/polls/{{ question.id }}/">{{ question.question_text }}</a></li>
```
The problem with this hardcoded, tightly-coupled approach is that it becomes challenging to change URLs on projects with a lot of templates. However, since you defined the name argument in the path() functions in the polls.urls module, you can remove a reliance on specific URL paths defined in your url configurations by using the `\{\% url \%\}` template tag:
The problem with this hardcoded, tightly-coupled approach is that it becomes challenging to change URLs on projects with a lot of templates. However, since you defined the name argument in the path() functions in the polls.urls module, you can remove a reliance on specific URL paths defined in your url configurations by using the `\{\% url \%\}` template tag:
```html
    <li><a href="{% url 'detail' question.id %}">{{ question.question_text }}</a></li>
```
The way this works is by looking up the URL definition as specified in the polls.urls module. You can see exactly where the URL name of ‘detail’ is defined below:
```html
    # the 'name' value as called by the {% url %} template tag
    path('<int:question_id>/', views.detail, name='detail'),
```

If you want to change the URL of the polls detail view to something else, perhaps to something like polls/specifics/12/ instead of doing it in the template (or templates) you would change it in polls/urls.py:
```html
    # added the word 'specifics'
    path('specifics/<int:question_id>/', views.detail, name='detail'),
```
##### Namespacing URL names
The answer is to add namespaces to your URLconf. In the polls/urls.py file, go ahead and add an app_name to set the application namespace:
```html
    from django.urls import path
    
    from . import views
    
    app_name = 'polls'
    urlpatterns = [
        path('', views.index, name='index'),
        path('<int:question_id>/', views.detail, name='detail'),
        path('<int:question_id>/results/', views.results, name='results'),
        path('<int:question_id>/vote/', views.vote, name='vote'),
    ]
```
Change your polls/index.html template from:
polls/templates/polls/index.html¶
```html
    <li><a href="{% url 'detail' question.id %}">{{ question.question_text }}</a></li>
```

to point at the namespaced detail view:
polls/templates/polls/index.html¶
```html
    <li><a href="{% url 'polls:detail' question.id %}">{{ question.question_text }}</a></li>
```


### 版本
其中，很令人头疼的便是版本。 如果遇到什么莫名其妙的错，请查看是否是版本的原因。
这里的版本原因并不☞一些人说的库依赖严重，好像开发者版本更迭不考虑兼容——或者说居然勤奋的接口重换那般严重。
此处仅仅☞在运行新版本时否个方法时，或许会莫名其妙引发一个早已摒弃的函数错误。这时候就可能是在折腾版本是导致有的不同版本有文件残留。在运行时莫名其妙的被`import`了然后它有调取其他东西，但是找不到的…  

这时候轻则`pip uninstall` 重则环境重建。所以可见虚拟环境还是挺有用的嘛——

### MVC
全名： `Model` 、`View`、`Controller`。模型，视图，控制器这种功能分离的软件设计规范。所以它是通用的…不要和爪哇捆绑，搞得和某个神奇技术一般…   (⊙﹏⊙)

---

## 简介
在安装之后，使用`django-admin startproject `+名字来初始化一个工程。   对比到`python`中就是创建好了文档目录，还在文件中写入相关框架代码，以此支持运行。

### 试一下?
`python manage.py runserver`
便可开启服务器，这时候访问相应端口，就一个欢迎界面，提示嗯~ o(*￣▽￣*)o，你能开跑了。
#### 再试一下？
在11版本中有`\admin`地址可以访问，访问之后便是一个登陆界面.<font color=#ef0000>但</font>,并不知道用户名和密码啊~   emm… 不过好处是能看到这个页面至少保证了`django`在`render`一个`.html`页面时是正常的。而之前说的<font color=#9e0000>老版本残留</font>就会导致`render`时出错。

### 结构
根目录下，'项目名文件'是项目容器😰
`manage.py` 命令行工具，emm 类似于`python click库`的命令行程序，使用参数干不同的事情。
进入到项目容器中，其中`settings.py`顾名思义
`urls.py`同上，管理各个`url`通往哪里
`wsgl.py`某个兼容啥，现在不用管…

### 得知结构之后
然后就能
1. 在`urls.py`里愉快的添加各个功能url。这里面就一个urlpatterns列表，使用`djangol.conf.urls.url`方法来配置。
不过其对应的执行函数都需要一个`request`来接受请求数据。 `return`回一个页面~ 现在用到的有`django,shortcuts.render 及 render_to_response`出来的，以及`django.http.HttpResponse`出来的东西。

2. 嗯…… `ulr` 链接的执行方法详情就放在新创建的`view.py`中管理。

3. 而在`view`中需要渲染的html文件则放置在根目录新创建的`templates`文件夹中。通过在`setting.py`中的'TEMPLATES'列表中的不知名字典(因为它确实没取名啊😔)de`DIRS`元素来指路。

### 这下可以很厉害了
进而进行数据库配置—— 还在`setting.py`中的'DATABASES'来指路。
但Django规定要使用模型，就要创建一个爱怕怕`app`：
```shell
django-admin startapp TestModel 🦑
```
再将此爱怕怕领到`setting.py`中`NSTALLED_APPS`中签一下到。
随后在`TestModel`下的`models`中创建继承于`django.db.models.Model`的数据类，然后使用隶属于`models`下的方法来制定数据类型eg:
```python 
name = models.CharField(max_length=20)
```
> 毕竟不能直接通过Python的自由类嘛… 然后也肯定不能通过python的制定类型… 毕竟python数据类型和MySQL天差地别。

<font color=a00070>最后</font>
再回到命令行中使用
```shell
python manage.py migrate        //创建表结构
python manage.py makemigrations //通知更改
python manage.py testModel      // 创建表结构 😲❓
正式拉入编制之后就能用了。
```
2019年1月23日
```
- Change your models(in *models.py*)
- Run *python manage.py makemigrations* to create migration for those changes
- Run *python manage.py migrate* to apply those changes to the database
```
Of courses, If Null Run *python manage.py migrate* can make a models.py whitch has nothings.

#### 那么这个数据库怎么操作呢？
自然是到`urls.py`中添加🔗链接到方法的路
再到容器里面添加t`estdb.py`来说明方法详细。
##### 增删改查
```python 
实例化类
直接.save()即保存
未实例化类，all标识查找全部
.objects.filter(填写删选条件)
.objects.get(获取)
.order_by(排序条件)
更改则是将查出来的东西直接修改.update(修改东西)
再.save保存
删除便是.delete()
``.
差不多了  之后的详细再随情况更新。

### 那么数据库表多了怎么一键生成对应类呢？
```shell
python manage.py inspectdb  //自动生成models模型文件
python manage.py inspectdb > app/models.py      //假设有了名为'app'的爱怕怕
// 老一套
python manage.py makemigrations
python manage.py migrate
```
但是会将之前`models.py`中的东西删掉… 还会把数据库中的表名重命名… 按它的规矩来生成，嗯…其实也🆗的。



## 我爱Java 2018年6月24日16点40分的我由衷的写到
在`MySQL`中读取`blob`存储的字段时，使用`BinaryField`不可使用其逆向生成的模型读取方式。当然，对照表如下
```md
            'AutoField': 'integer AUTO_INCREMENT',
            'BigAutoField': 'bigint AUTO_INCREMENT',
            'BinaryField': 'longblob',
            'BooleanField': 'bool',
            'CharField': 'varchar(%(max_length)s)',
            'CommaSeparatedIntegerField': 'varchar(%(max_length)s)',
            'DateField': 'date',
            'DateTimeField': 'datetime',
            'DecimalField': 'numeric(%(max_digits)s, %(decimal_places)s)',
            'DurationField': 'bigint',
            'FileField': 'varchar(%(max_length)s)',
            'FilePathField': 'varchar(%(max_length)s)',
            'FloatField': 'double precision',
            'IntegerField': 'integer',
            'BigIntegerField': 'bigint',
            'IPAddressField': 'char(15)',
            'GenericIPAddressField': 'char(39)',
            'NullBooleanField': 'bool',
            'OneToOneField': 'integer',
            'PositiveIntegerField': 'integer UNSIGNED',
            'PositiveSmallIntegerField': 'smallint UNSIGNED',
            'SlugField': 'varchar(%(max_length)s)',
            'SmallIntegerField': 'smallint',
            'TextField': 'longtext',
            'TimeField': 'time',
            'UUIDField': 'char(32)',

```
以上是一部分，具体点[这里](https://www.cnblogs.com/sun1994/p/8566988.html)
##### 模型字段名称
在逆向生成时，我遇到过一次将数据库名修改的先例，不过后来似乎没有修改过。  然后就是驼峰命名法的字段可能emm也是因为此我才开始写这些信息，就是，驼峰命名法的字段可能在模型字段中为全小写。  还有就是`Django`莫名其妙的的编码错误，真的是一分钟编程，一小时修改编码…而且调试起来真的…我目前的调试方式极为原始，所以感觉真的`不想编程`嗯… 

#### Django 返回文件下载
```py
    def readFile(fn, buf_size=262144):  # 大文件下载，设定缓存大小
        f = open(fn, "rb")
        while True:  # 循环读取
            c = f.read(buf_size)
            if c:
                yield c
            else:
                break
        f.close()
    response = HttpResponse(readFile(filePath), content_type='APPLICATION/OCTET-STREAM')  # 设定文件头，这种设定可以让任意文件都能正确下载，而且已知文本文件不是本地打开
    fileName = 'haya'
    fileType = '.docx'
    response['Content-Disposition'] = 'attachment; filename=' + fileName.encode('utf-8') + fileType.encode('utf-8')  # 设定传输给客户端的文件名称
    response['Content-Length'] = os.path.getsize(filePath)  # 传输给客户端的文件大小
    return response 
```

#### Python Docx编辑
##### 替换
```docx
    在`.docx`文件中将需要替换的位置 使用变量站位，写法{{ placheholdParaName }}
```
<font color=red>使用文件时，只能写做`{{placheholdParaName}}`不能有空格…另外`docx`使用`docx`中的`Document`读入即可</font>
```py
    tpl = DocxTemplate(self.prjRootPath + '/word_template/' + "word_template.docx")
    sub1 = tpl.new_subdoc()
    sub1.subdocx = Document(temPath + 'sub1_bond.docx')
    subContext['sub1'] = sub1
```
```md
    上述中，只能写作……难道是因为使用{{someThing}}这种写法而隐藏了？！！
    那么，今后写彩带注释岂不是不需要使用^_^而直接使用双花括号的写法就能直接隐藏了么(⊙o⊙ ) 　凄い
```
**Py中**：
```py
    from docxtpl import DocxTemplate, InlineImage
    from docx.shared import Mm, Inches, Pt
    doc = DocxTemplate("my_word_template.docx")
    myimage = InlineImage(doc,
    'C:/Users/GuPengxiang/Pictures/ha.jpg',width=Mm(20))
    context = { 'fundName' : u'这里是基金名称', 'stars':u'五星级琉璃六', '
    bench': u'对比基金', 'income': u'12', 'bb': u'0.1%', 'image0' : myimage}
    doc.render(context)
    doc.save("generated_doc.docx")
```
#### 生成echarts图表图片
##### 环境
```bash
# 更新软件列表 & 更新软件
sudo apt-get update    
sudo apt-get upgrade
# 下载包
pip install pyecharts-snapshot
wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.5.0-beta-linux-ubuntu-xenial-x86_64.tar.gz
# 解压
tar -xzvf phantomjs-2.5.0-beta-linux-ubuntu-xenial-x86_64.tar.gz
# 进入路径
cd phantomjs-2.5.0-beta-ubuntu-xenial/bin
# 赋予权限
chmod +x phantomjs
# 查看版本号
phantomjs -v  
# 若显示版本号，如 2.1.1 则生效
```
##### 生成图片
```py
from pyecharts import Line, Pie, Grid
from pyecharts_snapshot.main import make_a_snapshot

attr = ["衬衫", "羊毛衫", "雪纺衫", "裤子", "高跟鞋", "袜子"]
v1 = [5, 20, 36, 10, 10, 100]
v2 = [55, 60, 16, 20, 15, 80]
line = Line("折线图示例")
line.add("商家A", attr, v1, mark_point=["average"])
line.add("商家B", attr, v2, is_smooth=True, mark_line=["max", "average"])
line.render('test.html')

make_a_snapshot('test.html', 'test.pdf')
# 或者直接生成
line.render('test.png')
```
<font color= #f0aabb>在生成图片时，插件包文件源码中有Log，但却是print出来的，而在部署环境中不允许出现print，所以…… 得在包源码中将之屏蔽</font>

##### 连续生成图片
用以上方法来生成图片是…很慢的🐢⬅这个速度。但可以通过使用为渲染创建一个默认配置环境来避免多次生成环境配置。所以——  具体来看`pyecharts`中的[高级说明](http://pyecharts.org/#/zh-cn/prepare)🕶
```py
    from pyecharts import Bar, Line
    from pyecharts.engine import create_default_environment
    
    bar = Bar("我的第一个图表", "这里是副标题")
    bar.add("服装", ["衬衫", "羊毛衫", "雪纺衫", "裤子", "高跟鞋", "袜子"], [5, 20, 36, 10, 75, 90])
    
    line = Line("我的第一个图表", "这里是副标题")
    line.add("服装", ["衬衫", "羊毛衫", "雪纺衫", "裤子", "高跟鞋", "袜子"], [5, 20, 36, 10, 75, 90])
    
    env = create_default_environment("html")
    # 为渲染创建一个默认配置环境
    # create_default_environment(filet_ype)
    # file_type: 'html', 'svg', 'png', 'jpeg', 'gif' or 'pdf'
    
    env.render_chart_to_file(bar, path='bar.html')
    env.render_chart_to_file(line, path='line.html')
```

(*￣▽￣*)o   如上
### 注意
    在生成报表时， 由于采用的是浏览器截图的方式，在使用`phantomjs`时会自动判断图片是否加载完成（echarts在显示图表之前是有一段动画的……）然后再`pyecharts`中并没有关闭动画的接口，而echarts是有的。 但毕竟`echarts`是在做翻译，所以只要在"Chart"基类中，将`animation=False`就可以了。 我改的时候在`chart.py`文件的29行，def __init__中。


## SSl加密，https配置
虽然就配置过之后显得操作很简单，而且也很明显，但就配置之初着实还是费了一些功夫的。或许是因为大而全的东西懒得看，而网上搜索到的粘贴复制之词又太过片面，或许大家写的时候也就当作日记来写的，本就没准备让别人去参考。所以再加上搜索的时候俺表述词不达意，所以总是很曲折（呵，用谷歌搜外文网就不存在这问题，前面就谦虚一下🙃）
### 之前写的文档
1 ssl加密部署步骤说明文档
一．申请ssl证书
1.生成csr文件，可使用openssl工具生成
(1)例:`openssl genrsa -des3 -out server.key 1024`   生成服务器key文件;
(2)例:`openssl req -new -key server.key -out server.csr`    生成服务器证书请求CSR文件;
或使用CSR文件生成工具生成(例https://www.chinassl.net/ssltools/generator-csr.html，填写信息后点击生成CSR文件即可)
（CSR文件中包括组织部门、国家地区、算法、以及邮箱和域名等信息）
2.申请/购买HTTPS证书， 填写与上述相同的信息，验证类型选择DNS，CSR生成选择提供CSR(即提供第一步生成的CSR文件)（例：在阿里云或腾讯等地，本文档撰写时是通过https://freessl.org/ 免费申请而来（一年有效期，单域名，））
二、验证域名所属关系
1.到域名管理控制台中选择云解析DNS, 选择域名，添加“记录”，记录类型选择‘TXT’，主机记录及记录值填写证书申请方提供内容。
2.等待1分钟或10分钟后，等待生效
3.点击验证
三、证书下载
验证通过后，下载网站提供证书，含（CA证书、服务器证书、服务器私钥）
四、Apache2部署开启SSL加密
更改httpd.conf 文件设置：
1.Listen {内网IP}:80
2.开启models
(1)LoadModule ssl_module modules/mod_ssl.so
(2)LoadModule socache_shmcb_module modules/mod_socache_shmcb.so
(3)LoadModule rewrite_module modules/mod_rewrite.so
(4)ServerName {与域名相同}（未测试是否必须相同）
3.http跳转到https:
(1)RewriteEngine on
(2)RewriteCond %{SERVER_PORT} !^443$
(3)RewriteRule ^/?(.*)$ https://%{SERVER_NAME}/$1 [L,R]
更改extra/httpd-ssl.conf 文件设置
1.Listen 443
2.ServerName www.lejinrong.cn
3.ServerAdmin admin@lejinrong
4.SSLCertificateFile "c:/Apache24/conf/ssl/server.crt"
5.SSLCertificateKeyFile "c:/Apache24/conf/ssl/server.key"
第四步中crt文件指向服务器证书文件， 第五步中.key文件指向私钥文件
(其余部署方案或许有所不同，会使用CA证书)


1.1 注意： 确保服务器中防火墙入站规则中添加了80端口和443端口。




2 附：
2.1.1 本地测试方案：

环境：wamp Apache 2.4.9
前言：wamp安装好后，默认的只有http服务，以下配置启用https服务
条件：在Apache安装目录下需要有一下文件
         [Apache安装目录]/modules/ mod_ssl.so
         [Apache安装目录]/bin/ openssl.exe, libeay32.dll, ssleay32.dll
         [Apache安装目录]/conf/ openssl.cnf
步骤：
一、修改配置文件httpd.conf，去掉下面行首的#（载入ssl模块和其他配置文件）
LoadModule socache_shmcb_module modules/mod_socache_shmcb.so
LoadModule ssl_module modules/mod_ssl.so
Include conf/extra/httpd-ssl.conf
二、认证文件生成（生成证书签发请求）
进入Apache安装目录的bin目录下，输入cmd，进入DOS窗口，输入以下命令
openssl req -new -out server.csr -config ../conf/openssl.cnf
回车后提示输入密码和确认密码，本机输入：keypasswd
后面会提示输入一系列的参数
......
Country Name (2 letter code) [AU]: （要求输入国家缩写，只能输入2个字母，这里输入cn）
State or Province Name (full name) [Some-State]: （要求输入州名或省名，这里输入hubei）
Locality Name (eg, city) []: （要求输入城市名，这里输入wuhan）
Organization Name (eg, company) [Internet Widgits Pty Ltd]: （要求输入组织名或公司名，这里输入gg）
Organizational Unit Name (eg, section) []: （要求输入部门名，这里输入gg）
Common Name (eg, YOUR name) []: （要求输入服务器域名或IP地址）
Email Address []: （要求输入邮件地址）
A challenge password[]:（要求输入密码）
An optional company name[]（要求输入公司别名，这里输入ggs）
.....
生成私钥，在DOS窗口下的Apache的bin目录下输入命令
openssl rsa -in privkey.pem -out server.key
然后要求输入之前 privkey.pem 的密码（keypasswd)
创建证书，输入命令
openssl x509 -in server.csr -out server.crt -req -signkey server.key -days 8000
回车后，显示创建成功，有效期为 8000 天
将Apache的bin目录下的server.csr、server.crt、server.key拷贝到Apache安装目录下的conf\ssl，若没有ssl文件则创建
打开Apache安装目录conf/extra/httpd-ssl.conf文件，设置SSLCertificateFile和SSLCertificateKeyFile
SSLCertificateFile "C:/apache2.4.9/conf/ssl/server.crt"
SSLCertificateKeyFile "C:/apache2.4.9/conf/ssl/server.key"
最后重启Apache服务，HTTPS服务的默认监听端口为443
 
随后在本机中安装`server.crt`至`收信人的根证书颁发机构`即可不再提示证书无效
注意：在重启Apache时，若Apache服务启动不起来，则在Apache安装目录的bin目录下，输入httpd –t，可以根据提示来修改你的配置文件
### 附
现在是2018年8月25日16点01分 所以上面其实是一个月前写给别人看的文档。
在我搜的时候由于先在本地配置，尔后再网上找CA发证书，自我感觉这个步骤没有什么问题。就今天在

#### Apache配置双网站/https
的时候，也是这样，先在本地通过不同端口测试，确定方案之后再在服务器上通过`ServerName`进行区分。
也就是启用`httpd-vhosts.conf`之后，再
```md
# Virtual Hosts
#
# Required modules: mod_log_config

# If you want to maintain multiple domains/hostnames on your
# machine you can setup VirtualHost containers for them. Most configurations
# use only name-based virtual hosts so the server doesn't need to worry about
# IP addresses. This is indicated by the asterisks in the directives below.
#
# Please see the documentation at 
# <URL:http://httpd.apache.org/docs/2.4/vhosts/>
# for further details before you try to setup virtual hosts.
#
# You may use the command line option '-S' to verify your virtual host
# configuration.

#
# VirtualHost example:
# Almost any Apache directive may go into a VirtualHost container.
# The first VirtualHost section is used for all requests that do not
# match a ServerName or ServerAlias in any <VirtualHost> block.
#
<VirtualHost 192.168.1.81:80>
    ServerName www.lejinrong.cn
    ServerAlias www.lejinrong.cn
    ServerAdmin www.lejinrong.cn
    #指定myweb项目的wsgi.py配置文件路径  
    WSGIScriptAlias / D:/FundEvaluationSystem_svn1/Fund_Evaluation_System_V2/Fund_Evaluation_System/wsgi.py
    #配置静态变量路径
    Alias /static/ D:/FundEvaluationSystem_svn1/Fund_Evaluation_System_V2/static/
    <Directory D:/FundEvaluationSystem_svn1/Fund_Evaluation_System_V2/static>  
        Allow from all
    </Directory>
    DocumentRoot "D:/FundEvaluationSystem_svn1/Fund_Evaluation_System_V2"
    <Directory "D:/FundEvaluationSystem_svn1/Fund_Evaluation_System_V2">  
        Options Indexes FollowSymLinks
        AllowOverride None
    </Directory>
    RewriteEngine on
    RewriteCond %{SERVER_PORT} !^400$
    RewriteRule ^/?(.*)$ https://%{SERVER_NAME}/$1 [L,R]
    ErrorLog "logs/dummy-host.example.com-error.log"
    CustomLog "logs/dummy-host.example.com-access.log" common
</VirtualHost>

<VirtualHost 192.168.1.81:8880>
    ServerName lejinrong.cn
    ServerAlias vip.lejinrong.cn
    ServerAdmin vip.lejinrong.cn
    #指定myweb项目的wsgi.py配置文件路径  
    WSGIScriptAlias / D:/FundEvaluationSystem_svn1/Fund_Evaluation_System_V3/Fund_Evaluation_System/wsgi.py
    #配置静态变量路径
    Alias /static/ D:/FundEvaluationSystem_svn1/Fund_Evaluation_System_V3/static/
    <Directory D:/FundEvaluationSystem_svn1/Fund_Evaluation_System_V3/static>
        Allow from all
    </Directory>
    DocumentRoot "D:/FundEvaluationSystem_svn1/Fund_Evaluation_System_V3"
    <Directory "D:/FundEvaluationSystem_svn1/Fund_Evaluation_System_V3">  
        Options Indexes FollowSymLinks
        AllowOverride None
    </Directory>
    ErrorLog "logs/dummy-host.example.com-error.log"
    CustomLog "logs/dummy-host.example.com-access.log" common
    RewriteEngine on
    RewriteCond %{SERVER_PORT} !^443$
    RewriteRule ^/?(.*)$ https://%{SERVER_NAME}/$1 [L,R]
</VirtualHost>
```
同理，在`httpd-ssl.conf`中也是通过配置不同`VirtualHost`进行区分
```md
#
# This is the Apache server configuration file providing SSL support.
# It contains the configuration directives to instruct the server how to
# serve pages over an https connection. For detailed information about these 
# directives see <URL:http://httpd.apache.org/docs/2.4/mod/mod_ssl.html>
# 
# Do NOT simply read the instructions in here without understanding
# what they do.  They're here only as hints or reminders.  If you are unsure
# consult the online docs. You have been warned.  
#
# Required modules: mod_log_config, mod_setenvif, mod_ssl,
#          socache_shmcb_module (for default value of SSLSessionCache)

#
# Pseudo Random Number Generator (PRNG):
# Configure one or more sources to seed the PRNG of the SSL library.
# The seed data should be of good random quality.
# WARNING! On some platforms /dev/random blocks if not enough entropy
# is available. This means you then cannot use the /dev/random device
# because it would lead to very long connection times (as long as
# it requires to make more entropy available). But usually those
# platforms additionally provide a /dev/urandom device which doesn't
# block. So, if available, use this one instead. Read the mod_ssl User
# Manual for more details.
#
#SSLRandomSeed startup file:/dev/random  512
#SSLRandomSeed startup file:/dev/urandom 512
#SSLRandomSeed connect file:/dev/random  512
#SSLRandomSeed connect file:/dev/urandom 512


#
# When we also provide SSL we have to listen to the 
# standard HTTP port (see above) and to the HTTPS port
#
Listen 443
Listen 400
#ServerName www.lejinrong.cn
##
##  SSL Global Context
##
##  All SSL configuration in this context applies both to
##  the main server and all SSL-enabled virtual hosts.
##

#   SSL Cipher Suite:
#   List the ciphers that the client is permitted to negotiate,
#   and that httpd will negotiate as the client of a proxied server.
#   See the OpenSSL documentation for a complete list of ciphers, and
#   ensure these follow appropriate best practices for this deployment.
#   httpd 2.2.30, 2.4.13 and later force-disable aNULL, eNULL and EXP ciphers,
#   while OpenSSL disabled these by default in 0.9.8zf/1.0.0r/1.0.1m/1.0.2a.
SSLCipherSuite HIGH:MEDIUM:!MD5:!RC4:!3DES
SSLProxyCipherSuite HIGH:MEDIUM:!MD5:!RC4:!3DES

#  By the end of 2016, only TLSv1.2 ciphers should remain in use.
#  Older ciphers should be disallowed as soon as possible, while the
#  kRSA ciphers do not offer forward secrecy.  These changes inhibit
#  older clients (such as IE6 SP2 or IE8 on Windows XP, or other legacy
#  non-browser tooling) from successfully connecting.  
#
#  To restrict mod_ssl to use only TLSv1.2 ciphers, and disable
#  those protocols which do not support forward secrecy, replace
#  the SSLCipherSuite and SSLProxyCipherSuite directives above with
#  the following two directives, as soon as practical.
# SSLCipherSuite HIGH:MEDIUM:!SSLv3:!kRSA
# SSLProxyCipherSuite HIGH:MEDIUM:!SSLv3:!kRSA

#   User agents such as web browsers are not configured for the user's
#   own preference of either security or performance, therefore this
#   must be the prerogative of the web server administrator who manages
#   cpu load versus confidentiality, so enforce the server's cipher order.
SSLHonorCipherOrder on 

#   SSL Protocol support:
#   List the protocol versions which clients are allowed to connect with.
#   Disable SSLv3 by default (cf. RFC 7525 3.1.1).  TLSv1 (1.0) should be
#   disabled as quickly as practical.  By the end of 2016, only the TLSv1.2
#   protocol or later should remain in use.
SSLProtocol all -SSLv3
SSLProxyProtocol all -SSLv3

#   Pass Phrase Dialog:
#   Configure the pass phrase gathering process.
#   The filtering dialog program (`builtin' is an internal
#   terminal dialog) has to provide the pass phrase on stdout.
SSLPassPhraseDialog  builtin

#   Inter-Process Session Cache:
#   Configure the SSL Session Cache: First the mechanism 
#   to use and second the expiring timeout (in seconds).
#SSLSessionCache         "dbm:c:/Apache24/logs/ssl_scache"
SSLSessionCache        "shmcb:c:/Apache24/logs/ssl_scache(512000)"
SSLSessionCacheTimeout  300

#   OCSP Stapling (requires OpenSSL 0.9.8h or later)
#
#   This feature is disabled by default and requires at least
#   the two directives SSLUseStapling and SSLStaplingCache.
#   Refer to the documentation on OCSP Stapling in the SSL/TLS
#   How-To for more information.
#
#   Enable stapling for all SSL-enabled servers:
#SSLUseStapling On

#   Define a relatively small cache for OCSP Stapling using
#   the same mechanism that is used for the SSL session cache
#   above.  If stapling is used with more than a few certificates,
#   the size may need to be increased.  (AH01929 will be logged.)
#SSLStaplingCache "shmcb:c:/Apache24/logs/ssl_stapling(32768)"

#   Seconds before valid OCSP responses are expired from the cache
#SSLStaplingStandardCacheTimeout 3600

#   Seconds before invalid OCSP responses are expired from the cache
#SSLStaplingErrorCacheTimeout 600

##
## SSL Virtual Host Context
##

<VirtualHost 192.168.1.81:400>

#   General setup for the virtual host
DocumentRoot "c:/Apache24/htdocs"
ServerName www.lejinrong.cn
ServerAdmin admin@lejinrong.cn
ErrorLog "c:/Apache24/logs/error.log"
TransferLog "c:/Apache24/logs/access.log"

#   SSL Engine Switch:
#   Enable/Disable SSL for this virtual host.
SSLEngine on

#   Server Certificate:
#   Point SSLCertificateFile at a PEM encoded certificate.  If
#   the certificate is encrypted, then you will be prompted for a
#   pass phrase.  Note that a kill -HUP will prompt again.  Keep
#   in mind that if you have both an RSA and a DSA certificate you
#   can configure both in parallel (to also allow the use of DSA
#   ciphers, etc.)
#   Some ECC cipher suites (http://www.ietf.org/rfc/rfc4492.txt)
#   require an ECC certificate which can also be configured in
#   parallel.
SSLCertificateFile "c:/Apache24/conf/ssl/server.crt"
#SSLCertificateFile "c:/Apache24/conf/server-dsa.crt"
#SSLCertificateFile "c:/Apache24/conf/server-ecc.crt"

#   Server Private Key:
#   If the key is not combined with the certificate, use this
#   directive to point at the key file.  Keep in mind that if
#   you've both a RSA and a DSA private key you can configure
#   both in parallel (to also allow the use of DSA ciphers, etc.)
#   ECC keys, when in use, can also be configured in parallel
SSLCertificateKeyFile "c:/Apache24/conf/ssl/server.key"
#SSLCertificateKeyFile "c:/Apache24/conf/server-dsa.key"
#SSLCertificateKeyFile "c:/Apache24/conf/server-ecc.key"

#   Server Certificate Chain:
#   Point SSLCertificateChainFile at a file containing the
#   concatenation of PEM encoded CA certificates which form the
#   certificate chain for the server certificate. Alternatively
#   the referenced file can be the same as SSLCertificateFile
#   when the CA certificates are directly appended to the server
#   certificate for convenience.
#SSLCertificateChainFile "c:/Apache24/conf/server-ca.crt"

#   Certificate Authority (CA):
#   Set the CA certificate verification path where to find CA
#   certificates for client authentication or alternatively one
#   huge file containing all of them (file must be PEM encoded)
#   Note: Inside SSLCACertificatePath you need hash symlinks
#         to point to the certificate files. Use the provided
#         Makefile to update the hash symlinks after changes.
#SSLCACertificatePath "c:/Apache24/conf/ssl.crt"
#SSLCACertificateFile "c:/Apache24/conf/ssl.crt/ca-bundle.crt"

#   Certificate Revocation Lists (CRL):
#   Set the CA revocation path where to find CA CRLs for client
#   authentication or alternatively one huge file containing all
#   of them (file must be PEM encoded).
#   The CRL checking mode needs to be configured explicitly
#   through SSLCARevocationCheck (defaults to "none" otherwise).
#   Note: Inside SSLCARevocationPath you need hash symlinks
#         to point to the certificate files. Use the provided
#         Makefile to update the hash symlinks after changes.
#SSLCARevocationPath "c:/Apache24/conf/ssl.crl"
#SSLCARevocationFile "c:/Apache24/conf/ssl.crl/ca-bundle.crl"
#SSLCARevocationCheck chain

#   Client Authentication (Type):
#   Client certificate verification type and depth.  Types are
#   none, optional, require and optional_no_ca.  Depth is a
#   number which specifies how deeply to verify the certificate
#   issuer chain before deciding the certificate is not valid.
#SSLVerifyClient require
#SSLVerifyDepth  10

#   TLS-SRP mutual authentication:
#   Enable TLS-SRP and set the path to the OpenSSL SRP verifier
#   file (containing login information for SRP user accounts). 
#   Requires OpenSSL 1.0.1 or newer. See the mod_ssl FAQ for
#   detailed instructions on creating this file. Example:
#   "openssl srp -srpvfile c:/Apache24/conf/passwd.srpv -add username"
#SSLSRPVerifierFile "c:/Apache24/conf/passwd.srpv"

#   Access Control:
#   With SSLRequire you can do per-directory access control based
#   on arbitrary complex boolean expressions containing server
#   variable checks and other lookup directives.  The syntax is a
#   mixture between C and Perl.  See the mod_ssl documentation
#   for more details.
#<Location />
#SSLRequire (    %{SSL_CIPHER} !~ m/^(EXP|NULL)/ \
#            and %{SSL_CLIENT_S_DN_O} eq "Snake Oil, Ltd." \
#            and %{SSL_CLIENT_S_DN_OU} in {"Staff", "CA", "Dev"} \
#            and %{TIME_WDAY} >= 1 and %{TIME_WDAY} <= 5 \
#            and %{TIME_HOUR} >= 8 and %{TIME_HOUR} <= 20       ) \
#           or %{REMOTE_ADDR} =~ m/^192\.76\.162\.[0-9]+$/
#</Location>

#   SSL Engine Options:
#   Set various options for the SSL engine.
#   o FakeBasicAuth:
#     Translate the client X.509 into a Basic Authorisation.  This means that
#     the standard Auth/DBMAuth methods can be used for access control.  The
#     user name is the `one line' version of the client's X.509 certificate.
#     Note that no password is obtained from the user. Every entry in the user
#     file needs this password: `xxj31ZMTZzkVA'.
#   o ExportCertData:
#     This exports two additional environment variables: SSL_CLIENT_CERT and
#     SSL_SERVER_CERT. These contain the PEM-encoded certificates of the
#     server (always existing) and the client (only existing when client
#     authentication is used). This can be used to import the certificates
#     into CGI scripts.
#   o StdEnvVars:
#     This exports the standard SSL/TLS related `SSL_*' environment variables.
#     Per default this exportation is switched off for performance reasons,
#     because the extraction step is an expensive operation and is usually
#     useless for serving static content. So one usually enables the
#     exportation for CGI and SSI requests only.
#   o StrictRequire:
#     This denies access when "SSLRequireSSL" or "SSLRequire" applied even
#     under a "Satisfy any" situation, i.e. when it applies access is denied
#     and no other module can change it.
#   o OptRenegotiate:
#     This enables optimized SSL connection renegotiation handling when SSL
#     directives are used in per-directory context. 
#SSLOptions +FakeBasicAuth +ExportCertData +StrictRequire
<FilesMatch "\.(cgi|shtml|phtml|php)$">
    SSLOptions +StdEnvVars
</FilesMatch>
<Directory "c:/Apache24/cgi-bin">
    SSLOptions +StdEnvVars
</Directory>

#   SSL Protocol Adjustments:
#   The safe and default but still SSL/TLS standard compliant shutdown
#   approach is that mod_ssl sends the close notify alert but doesn't wait for
#   the close notify alert from client. When you need a different shutdown
#   approach you can use one of the following variables:
#   o ssl-unclean-shutdown:
#     This forces an unclean shutdown when the connection is closed, i.e. no
#     SSL close notify alert is sent or allowed to be received.  This violates
#     the SSL/TLS standard but is needed for some brain-dead browsers. Use
#     this when you receive I/O errors because of the standard approach where
#     mod_ssl sends the close notify alert.
#   o ssl-accurate-shutdown:
#     This forces an accurate shutdown when the connection is closed, i.e. a
#     SSL close notify alert is send and mod_ssl waits for the close notify
#     alert of the client. This is 100% SSL/TLS standard compliant, but in
#     practice often causes hanging connections with brain-dead browsers. Use
#     this only for browsers where you know that their SSL implementation
#     works correctly. 
#   Notice: Most problems of broken clients are also related to the HTTP
#   keep-alive facility, so you usually additionally want to disable
#   keep-alive for those clients, too. Use variable "nokeepalive" for this.
#   Similarly, one has to force some clients to use HTTP/1.0 to workaround
#   their broken HTTP/1.1 implementation. Use variables "downgrade-1.0" and
#   "force-response-1.0" for this.
BrowserMatch "MSIE [2-5]" \
         nokeepalive ssl-unclean-shutdown \
         downgrade-1.0 force-response-1.0

#   Per-Server Logging:
#   The home of a custom SSL log file. Use this when you want a
#   compact non-error SSL logfile on a virtual host basis.
CustomLog "c:/Apache24/logs/ssl_request.log" \
          "%t %h %{SSL_PROTOCOL}x %{SSL_CIPHER}x \"%r\" %b"
#指定myweb项目的wsgi.py配置文件路径  
WSGIScriptAlias / D:/FundEvaluationSystem_svn1/Fund_Evaluation_System_V2/Fund_Evaluation_System/wsgi.py
#配置静态变量路径
Alias /static/ D:/FundEvaluationSystem_svn1/Fund_Evaluation_System_V2/static/
<Directory D:/FundEvaluationSystem_svn1/Fund_Evaluation_System_V2/static>  
    Allow from all
</Directory>
DocumentRoot "D:/FundEvaluationSystem_svn1/Fund_Evaluation_System_V2"
<Directory "D:/FundEvaluationSystem_svn1/Fund_Evaluation_System_V2">  
    Options Indexes FollowSymLinks
    AllowOverride None
</Directory>

</VirtualHost>

<VirtualHost 192.168.1.81:443>
DocumentRoot "c:/Apache24/htdocs"
ServerName www.lejinrong.cn
ServerAdmin admin@lejinrong.cn
ErrorLog "c:/Apache24/logs/error.log"
TransferLog "c:/Apache24/logs/access.log"
SSLEngine on
SSLCertificateFile "c:/Apache24/conf/ssl/server.crt"
SSLCertificateKeyFile "c:/Apache24/conf/ssl/server.key"
<FilesMatch "\.(cgi|shtml|phtml|php)$">
    SSLOptions +StdEnvVars
</FilesMatch>
<Directory "c:/Apache24/cgi-bin">
    SSLOptions +StdEnvVars
</Directory>
BrowserMatch "MSIE [2-5]" \
         nokeepalive ssl-unclean-shutdown \
         downgrade-1.0 force-response-1.0
CustomLog "c:/Apache24/logs/ssl_request.log" \
          "%t %h %{SSL_PROTOCOL}x %{SSL_CIPHER}x \"%r\" %b"
WSGIScriptAlias / D:/FundEvaluationSystem_svn1/Fund_Evaluation_System_V3/Fund_Evaluation_System/wsgi.py
Alias /static/ D:/FundEvaluationSystem_svn1/Fund_Evaluation_System_V3/static/
<Directory D:/FundEvaluationSystem_svn1/Fund_Evaluation_System_V3/static>  
    Allow from all
</Directory>
DocumentRoot "D:/FundEvaluationSystem_svn1/Fund_Evaluation_System_V3"
<Directory "D:/FundEvaluationSystem_svn1/Fund_Evaluation_System_V3">  
    Options Indexes FollowSymLinks
    AllowOverride None
</Directory>
</VirtualHost>
```
但其实 都写了跳转，所以在`httpd-vhosts.conf`文件中的项目以及静态资源路径指定就不用指定了，只不过我懒得删…
还有一个坑点就是 原本有一个指定项目路径以及python环境的语句：
```md
#WSGIPythonPath "C:/Python27/Lib;C:/Python27/Lib/site-packages;C:/Python27/DLLs"
#WSGIPythonPath D:/FundEvaluationSystem_svn1
#WSGIPythonHome "C:/Python27"
```
我不知道按照上下这两种为什么会出问题，但网上那些人不会。但中间那个是用来指向项目路径的一个取巧的办法。哦因为wsgi或许我已经在别处制订过了。所以只要在`wsgi.py`中声明`sys.path.append('D:/FundEvaluationSystem_svn1/Fund_Evaluation_System_V2')`就可以将项目包括进来，而不需要通过 第二句那个制定`python`路径的东西。而用那个，会导致资源只有声明的项目1会被加载，而项目2的资源就不会声明，而将那三句话注释，只要分别在'wsgi.py'中声明项目资源，而在`.conf`文件中指向'wsgi.py'文件就可以如数加载了。

(⊙﹏⊙)语序  逻辑混乱之后不加班了再整理吧~~😭


# 前端 Vue
`vue`的使用方式可以通过`html`页面直接引用，也能直接用`vue-cil`创建项目。 网上人称`vue`脚手架？晓不大得
而我这里自然说的就是 `vue-cil`即 通过`vue init webpack <prjName>`来生成的项目喽

系统的创建以及介绍之后使用再熟一些再写，现在先记一些零散的东西。 [^_^]2018年9月18日 21点36分

### 路由配置登陆访问
```vue
    在`router/index.js`中：
    
    {
      path: '/',
      // 首页
      name: 'Main',
      component: Main,
      meta: {
        requireAuth: true,  // 添加该字段，表示进入这个路由是需要登录的
      }
    },
```

