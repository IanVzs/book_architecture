---
title: 机器学习库
date: 2017-07-24 18:40
modified: 2017-08-07 11:15
category: [note, learning]
tags: [ml, python]
slug: [pandas, numpy, tensorflow]
author: Ian
---


# Python 机器学习库 👽

### Plotly
与matplotlib 都是绘图工具，不过效果炫一些，我也没画过，所以只放链接，不放实例了
    [Plotly Python Library](https://plot.ly/python/) :  <https://plot.ly/python/>
## matplotlib
    import matplotlib.pyplot as plt
### 参数等太多，链接最可靠
[pyplot参数](https://github.com/wizardforcel/matplotlib-user-guide-zh/blob/master/3.1.md)

还是粘一些常用的：
    marker 属性（下面写在分号里呦）
    o  .  v  ^   <  >  1  2 3 4  8  s  p  *   h  H  +  x  D  d   |   _  之类

[画出一些“花儿”](http://blog.csdn.net/pipisorry/article/details/40005163)
### 绘图
    plt.plot(x, y)
    # 在y之后可添加参数，例如常用的label = ‘IamLabel’之类
    # 线的样式、颜色 ：b: blue  g: green    r: red  c: cyan m: magenta
    y: yellow   k: black    w: white
    '-' : solid , '--' : dashed, '-.' : dashdot ':' : dotted    '   '', ' '   ': None
    # 粗细 lw=3 更改数字
    # 数值折点显示样式 marker = ‘o’   

    plot.show()
### 绘制图表
#### 1
    plt.figure(1)
    绘图
    plt.figure(2)
    绘图
#### 2（未测试）
    plt.figure(1)   # 创建图表1
    plt.figure(2)   # 创建图表2
    hi1 = plt.subplot(211)  # 在图表2中创建子图1
    hi2 = plt.subplot(212)  # 在图表2中创建子图2
### 一表多图
    pCapital = plt.subplot(4, 1, 1)
        pCapital.set_ylabel("capital")
        pCapital.plot(d['capitalList'], color='r', lw=0.8)
    plt.show()
### 标注点
#### eg1
    for w, m in enumerate(self.lowestPrice):
            if w % 120*10 == 0:
                plt.plot([w, w], [m, self.highestPrice[w]], linestyle = '--')
            #plt.scatter(self.dealPoints,color = 'c')
    for i in self.dealPoints:           
        plt.scatter([i[0]], [i[1]], color = 'c')    
        for ii in self.ydealPoints:
        plt.scatter([ii[0]], [ii[1]], color = 'm')
        
    plt.title('Tick & TradePoint')
    plt.legend()
    plt.show()

<b>plt.legend()</b>
    # show() 之前不加这句是不会显示出标注的呦
#### eg2(还不晓得咋回事儿)

```python
import numpy as np
t = 2 * np.pi / 3
plt.plot([t, t], [0, np.cos(t)], color='blue', linewidth=2.5, linestyle="--")
plt.scatter([t, ], [np.cos(t), ], 50, color='blue')

plt.annotate(r'$sin(\frac{2\pi}{3})=\frac{\sqrt{3}}{2}$',
	xy=(t, np.sin(t)), xycoords='data',
	xytext=(+10, +30), textcoords='offset points', fontsize=16,
	arrowprops=dict(arrowstyle="->", connectionstyle="arc3,rad=.2"))

plt.plot([t, t],[0, np.sin(t)], color='red', linewidth=2.5, linestyle="--")
plt.scatter([t, ],[np.sin(t), ], 50, color='red')

plt.annotate(r'$cos(\frac{2\pi}{3})=-\frac{1}{2}$',
	xy=(t, np.cos(t)), xycoords='data',
	xytext=(-90, -50), textcoords='offset points', fontsize=16,
arrowprops=dict(arrowstyle="->", connectionstyle="arc3,rad=.2"))
```

### 坐标标签显示方案
```python
    plt.setp(plt.gca().get_xticklabels(), rotation=20, horizontalalignment='right')
    # 貌似除了角度和right，没有了修改内容
```
### 来画一个动态图吧（感觉没啥作用所以就小标题了）
```python
    import matplotlib.pyplot as plt
    from matplotlib.patches import Circle
    import numpy as np
    import math
    
    plt.close()  #clf() # 清图  cla() # 清坐标轴 close() # 关窗口
    fig=plt.figure()
    ax=fig.add_subplot(1,1,1)
    ax.axis("equal") #设置图像显示的时候XY轴比例
    plt.grid(True) #添加网格
    plt.ion()   #interactive mode on打开交互模式 而不是plt.show()
    IniObsX=0000
    IniObsY=4000
    IniObsAngle=135
    IniObsSpeed=10*math.sqrt(2)   #米/秒
    print('开始仿真')
    try:
        for t in range(180):
                #障碍物船只轨迹             
            obsX=IniObsX+IniObsSpeed*math.sin(IniObsAngle/180*math.pi)*t
            obsY=IniObsY+IniObsSpeed*math.cos(IniObsAngle/180*math.pi)*t
            ax.scatter(obsX,obsY,c='b',marker='.')  
            #散点图
            #ax.lines.pop(1)  删除轨迹
            #下面的图,两船的距离
            plt.pause(0.1)
    except Exception as err:
        print(err)
```
## pandas
### DataFrame
```python
    import pandas as pd
    import numpy as np
    a = {'a':['A','B','C'], 'b':[1,2,3], 'c':['lo', 'hel', 'hi'], 'd':[7,8,9]}

    df = pd.DataFrame(a)
    # 字典转换为dataFrame（每一个Key 和 Value构成一列，key为列标）
    df = df.set_index('a')
    # 将‘a‘列设置为行标
    sr = pd.Series(a)
    sr2 = df['b']

    df[['b','c']].to_records()[1]['b']
    df[['b','c']]
```
#### columns  index
    列，参数(行)
#### 取用方法
```python 
    dfValue.loc[indexKey][colKey]
```

#### 一个将`DataFrame`字符串化之后重新解析的程序😓
```python 
    def parseSTR(self, _str, indexKey, colKey, setIndexNum=0, setColNum=0):
        """
        通过setIndexNum来确定第几列数据为行标题， setColNum确定使用第几行数据作为列标题
        返回通过indexKey行标题 与 colKey列标题 确定的结果
        """
        rows = _str.split('\n')
        columns = rows[0].split(',')[1:]
        tempRow = []
        index = []
        for row in rows[1:]:
            if len(row):
                index.append(row.split(',')[setIndexNum])
                tempRow.append(row.split(',')[1:])
        dfValue = pd.DataFrame(tempRow, index=index, columns=columns)
        try:
            return dfValue.loc[indexKey][colKey]
        except:
            print u'【error:】信息不全'
            return None
```
Emm,有点儿…  嗯…   嗯… 
[^_^]:
    2018年6月21日17点17分
## numpy
### random
    random.seed(int类型) 
    # 理解可以为设定开始随机的开始，也就是说每次设定之后再开始取值就会得到相同的随机数()

即
    np.random.seed(1)   
    np.random.random(1)  

    np.random.seed(1)   
    np.random.random(1)
>array([ 0.417022])

>array([ 0.417022])

#### 标准差
    a = np.arange(10)
    np.std(a)
    a.std()
##### 样本标准差
    a.std(ddof = 1)
    np.std(a, ddof = 1)
以上 a.std 只有当a为<type 'numpy.ndarray'>  即用numpy生成的矩阵，array([0, 1, 2, 3, 4, 5, 6, 7, 8, 9])才可有，如果是python的列表list 则只能用np.std 来算

## scikit-learn

## OpenCV
### Insatll
caffe：

    sudo apt-get install libprotobuf-dev libleveldb-dev libsnappy-dev libopencv-dev libhdf5-serial-dev protobuf-compiler
    sudo apt-get install --no-install-recommends libboost-all-dev
    
    sudo apt-get install libatlas-base-dev

    sudo apt-get install libgflags-dev libgoogle-glog-dev liblmdb-dev


## PIL
    his = im.histogram()
values = {}

for i in range(256):
    values[i] = his[i]

for j,k in sorted(values.items(),key=lambda x:x[1],reverse = True)[:10]:
    print j,k






# 爬虫
 先[链接](https://edu.hellobi.com/course/156/reviews) 为实例视频教程，貌似不错，还没看。

## 问题
虽然, 以前已经积累了一些东西, 知道
- headers
- cookie
啥的, 但今天突然碰到了这个报错:
> Caused by SSLError(SSLError("bad handshake: Error([('SSL routines', 'tls_process_server_certificate', 'certificate verify failed')])

没见过, 之后碰到其余, 统一汇总在此.
### SSLError HTTPS
有人指点到: 因用`https`的缘故, 其中报 `verify failed` 所以可以通过
```py
requests.get(url, verify=False)
```
将`verify`关闭可通过.

## Selenium
#### 从网页粘来的，下方有作者以及来源链接，格式就保留原有不改了…
<h2>1、基本使用</h2><div class="highlight"><pre><code class="language-text"><span></span>from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.wait import WebDriverWait

browser = webdriver.Chrome()
browser.get('https://www.taobao.com/')
#### 显示等待10s
wait = WebDriverWait(browser, 10)
#### 等待直到元素加载出
input = wait.until(EC.presence_of_element_located((By.ID, 'q')))
#### 等待直到元素可点击
button = wait.until(EC.element_to_be_clickable((By.CSS_SELECTOR, '.btn-search')))
print(input, button)
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.wait import WebDriverWait

#### 创建一个浏览器对象
browser = webdriver.Chrome()
try:
    # 开启一个浏览器并访问https://www.baidu.com
    browser.get('https://www.baidu.com')
    # 在打开的网页响应中根据id查找元素   获取到查询框
    input = browser.find_element_by_id('kw')
    # 向查询框中输入Python
    input.send_keys('Python')
    # 模拟回车
    input.send_keys(Keys.ENTER)
    # 显示等待， 等待10秒
    wait = WebDriverWait(browser, 10)
    # 显式等待指定某个条件，然后设置最长等待时间。如果在这个时间还没有找到元素，那么便会抛出异常
    wait.until(EC.presence_of_element_located((By.ID,'content_left')))
    # 输出当前的url
    print(browser.current_url)
    # 输出Cookies
    print(browser.get_cookies())
    # 输出页面响应内容
    print(browser.page_source)
finally:
    pass
    # 关闭浏览器
    browser.close()
</code></pre></div><p><br></p><h2>2、Selenium声明浏览器对象</h2><div class="highlight"><pre><code class="language-text"><span></span>from selenium import webdriver

browser = webdriver.Chrome()
browser = webdriver.Firefox()
browser = webdriver.Edge()
browser = webdriver.PhantomJS()
browser = webdriver.Safari()
</code></pre></div><p><br></p><h2>3、查找元素</h2><h2>3.1、查找单个元素</h2><div class="highlight"><pre><code class="language-text"><span></span>from selenium import webdriver

#### 申明一个浏览器对象
browser = webdriver.Chrome()
#### 使用浏览器访问淘宝
browser.get('https://www.taobao.com')
#### 在响应结果中通过id查找元素
input_first = browser.find_element_by_id('q')
#### 在响应结果中通过css选择器查找元素
input_second = browser.find_element_by_css_selector('#q')
#### 在响应结果中通过xpath查找元素
input_third = browser.find_element_by_xpath('//*[@id="q"]')
print(input_first)
print(input_second)
print(input_third)
browser.close()
</code></pre></div><ul><li>find_element_by_name   通过name查找</li><li>find_element_by_xpath  通过xpath查找</li><li>find_element_by_link_text   通过链接查找</li><li>find_element_by_partial_link_text    通过部分链接查找</li><li>find_element_by_tag_name   通过标签名称查找</li><li>find_element_by_class_name   通过类名查找</li><li>find_element_by_css_selector  通过css选择武器查找</li></ul><p><br></p><div class="highlight"><pre><code class="language-text"><span></span>from selenium import webdriver
from selenium.webdriver.common.by import By

#### 申明一个浏览器对象
browser = webdriver.Chrome()
#### 使用浏览器访问淘宝
browser.get('https://www.taobao.com')
#### 第二种方式，通过使用By.xxx指定查找方式
input = browser.find_element(By.ID,'q')
print(input)
browser.close()
</code></pre></div><h2>3.2、多个元素</h2><div class="highlight"><pre><code class="language-text"><span></span>from selenium import webdriver
from selenium.webdriver.common.by import By

#### 申明一个浏览器对象
browser = webdriver.Chrome()
#### 使用浏览器访问淘宝
browser.get('https://www.taobao.com')
#### 根据选择查找多个元素
input_first = browser.find_elements_by_css_selector('.service-bd li')
input_second = browser.find_elements(By.CSS_SELECTOR,'.service-bd li')
print(input_first)
print(input_second)
browser.close()
</code></pre></div><ul><li>find_elements_by_name</li><li>find_elements_by_xpath</li><li>find_elements_by_link_text</li><li>find_elements_by_partial_link_text</li><li>find_elements_by_tag_name</li><li>find_elements_by_class_name</li><li>find_elements_by_css_selector</li></ul><p><br></p><p><br></p><h2>4、元素交互操作</h2><blockquote>对获取的元素调用交互方法 </blockquote><div class="highlight"><pre><code class="language-text"><span></span>import time
from selenium import webdriver
from selenium.webdriver.common.by import By

#### 申明一个浏览器对象
browser = webdriver.Chrome()
#### 使用浏览器访问淘宝
browser.get('https://www.taobao.com')
#### 根据ID查找元素
input_search = browser.find_element(By.ID,'q')
#### 模拟输入PSV到输入框
input_search.send_keys('PSV')
time.sleep(2)
#### 清空输入
input_search.clear()
input_search.send_keys('3DS')
button = browser.find_element(By.CLASS_NAME,'btn-search')
#### 模拟点击
button.click()
</code></pre></div><blockquote>更多的操作 <br><a href="http://link.zhihu.com/?target=http%3A//selenium-python.readthedocs.io/api.html%23module-selenium.webdriver.remote.webelement" class=" external" target="_blank" rel="nofollow noreferrer"><span class="invisible">http://</span><span class="visible">selenium-python.readthedocs.io</span><span class="invisible">/api.html#module-selenium.webdriver.remote.webelement</span><span class="ellipsis"></span><i class="icon-external"></i></a></blockquote><p><br></p><h2>5、交互动作</h2><div class="highlight"><pre><code class="language-text"><span></span>from selenium import webdriver
from selenium.webdriver import ActionChains

browser = webdriver.Chrome()
url = 'http://www.runoob.com/try/try.php?filename=jqueryui-api-droppable'
browser.get(url)
#### 切换id为iframeResult的frame
browser.switch_to.frame('iframeResult')
source = browser.find_element_by_css_selector('#draggable')
target = browser.find_element_by_css_selector('#droppable')
actions = ActionChains(browser)
actions.drag_and_drop(source, target)
actions.perform()
</code></pre></div><blockquote>更多操作<br><br><a href="http://link.zhihu.com/?target=http%3A//selenium-python.readthedocs.io/api.html%23module-selenium.webdriver.common.action_chains" class=" external" target="_blank" rel="nofollow noreferrer"><span class="invisible">http://</span><span class="visible">selenium-python.readthedocs.io</span><span class="invisible">/api.html#module-selenium.webdriver.common.action_chains</span><span class="ellipsis"></span><i class="icon-external"></i></a></blockquote><p><br></p><h2>6、执行JavaScript</h2><div class="highlight"><pre><code class="language-text"><span></span>from selenium import webdriver

#### 申明一个浏览器对象
browser = webdriver.Chrome()
browser.get('https://www.zhihu.com/explore')
#### 执行JavaScript脚本
browser.execute_script('window.scrollTo(0, document.body.scrollHeight)')
browser.execute_script('alert("To Bottom")')
</code></pre></div><h2>7、获取元素信息</h2><h2>7.1、获取属性</h2><div class="highlight"><pre><code class="language-text"><span></span>from selenium import webdriver
from selenium.webdriver.common.by import By

#### 申明一个浏览器对象
browser = webdriver.Chrome()
browser.get('https://www.zhihu.com/explore')
logo = browser.find_element(By.ID,'zh-top-link-logo')
#### 获取属性
print(logo.get_attribute('class'))
print(logo)
browser.close()
</code></pre></div><h2>7.2、获取文本值</h2><div class="highlight"><pre><code class="language-text"><span></span>from selenium import webdriver
from selenium.webdriver.common.by import By

#### 申明一个浏览器对象
browser = webdriver.Chrome()
browser.get('https://www.zhihu.com/explore')
submit = browser.find_element(By.ID,'zu-top-add-question')
#### 获取文本值
print(submit.text)
print(submit)
browser.close()
</code></pre></div><h2>7.3、获取ID、位置、标签名、大小</h2><div class="highlight"><pre><code class="language-text"><span></span>from selenium import webdriver
from selenium.webdriver.common.by import By

#### 申明一个浏览器对象
browser = webdriver.Chrome()
browser.get('https://www.zhihu.com/explore')
submit = browser.find_element(By.ID,'zu-top-add-question')
#### 获取id   0.04584255991652042-1
print(submit.id)
#### 获取位置  {'y': 7, 'x': 675}
print(submit.location)
#### 获取标签名称    button
print(submit.tag_name)
#### 获取大小  {'width': 66, 'height': 32}
print(submit.size)
browser.close()
</code></pre></div><h2>8、Frame</h2><div class="highlight"><pre><code class="language-text"><span></span>from selenium import webdriver
from selenium.common.exceptions import NoSuchElementException

browser = webdriver.Chrome()
url = 'http://www.runoob.com/try/try.php?filename=jqueryui-api-droppable'
browser.get(url)
#### 将操作的响应数据换成iframeResult
browser.switch_to.frame('iframeResult')
source = browser.find_element_by_css_selector('#draggable')
print(source)
try:
    logo = browser.find_element_by_class_name('logo')
except NoSuchElementException:
    print('NO LOGO')
#### 切换成父元素
browser.switch_to.parent_frame()
logo = browser.find_element_by_class_name('logo')
print(logo)
print(logo.text)
</code></pre></div><p><br></p><h2>9、等待</h2><h2>9.1、隐式等待</h2><blockquote>当使用了隐式等待执行测试的时候，如果 WebDriver没有在 DOM中找到元素，将继续等待，超出设定时间后则抛出找不到元素的异常, 换句话说，当查找元素或元素并没有立即出现的时候，隐式等待将等待一段时间再查找 DOM，默认的时间是0</blockquote><div class="highlight"><pre><code class="language-text"><span></span>from selenium import webdriver

browser = webdriver.Chrome()
#### 等待10秒
browser.implicitly_wait(10)
browser.get('https://www.zhihu.com/explore')
input = browser.find_element_by_class_name('zu-top-add-question')
print(input)
</code></pre></div><h2>9.2、显示等待</h2><blockquote>显式等待指定某个条件，然后设置最长等待时间。如果在这个时间还没有找到元素，那么便会抛出异常了。 </blockquote><div class="highlight"><pre><code class="language-text"><span></span>from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.wait import WebDriverWait

browser = webdriver.Chrome()
browser.get('https://www.taobao.com/')
#### 显示等待10s
wait = WebDriverWait(browser, 10)
#### 等待直到元素加载出
input = wait.until(EC.presence_of_element_located((By.ID, 'q')))
#### 等待直到元素可点击
button = wait.until(EC.element_to_be_clickable((By.CSS_SELECTOR, '.btn-search')))
print(input, button)
</code></pre></div><ul><li>title_is 标题是某内容</li><li>title_contains 标题包含某内容</li><li>presence_of_element_located 元素加载出，传入定位元组，如(By.ID, 'p')</li><li>visibility_of_element_located 元素可见，传入定位元组</li><li>visibility_of 可见，传入元素对象</li><li>presence_of_all_elements_located 所有元素加载出</li><li>text_to_be_present_in_element 某个元素文本包含某文字</li><li>text_to_be_present_in_element_value 某个元素值包含某文字</li><li>frame_to_be_available_and_switch_to_it frame加载并切换</li><li>invisibility_of_element_located 元素不可见</li><li>element_to_be_clickable 元素可点击</li><li>staleness_of 判断一个元素是否仍在DOM，可判断页面是否已经刷新</li><li>element_to_be_selected 元素可选择，传元素对象</li><li>element_located_to_be_selected 元素可选择，传入定位元组</li><li>element_selection_state_to_be 传入元素对象以及状态，相等返回True，否则返回False</li><li>element_located_selection_state_to_be 传入定位元组以及状态，相等返回True，否则返回False</li><li>alert_is_present 是否出现Alert</li></ul><p>更多操作</p><blockquote><a href="http://link.zhihu.com/?target=http%3A//selenium-python.readthedocs.io/api.html%23module-selenium.webdriver.support.expected_conditions" class=" external" target="_blank" rel="nofollow noreferrer"><span class="invisible">http://</span><span class="visible">selenium-python.readthedocs.io</span><span class="invisible">/api.html#module-selenium.webdriver.support.expected_conditions</span><span class="ellipsis"></span><i class="icon-external"></i></a></blockquote><p><br></p><h2>10、前进后退</h2><div class="highlight"><pre><code class="language-text"><span></span>import time
from selenium import webdriver

browser = webdriver.Chrome()
browser.get('https://www.baidu.com/')
browser.get('https://www.taobao.com/')
browser.get('https://www.python.org/')
browser.back()
time.sleep(1)
browser.forward()
browser.close()
</code></pre></div><p><br></p><h2>11、Cookies</h2><div class="highlight"><pre><code class="language-text"><span></span>from selenium import webdriver

browser = webdriver.Chrome()
browser.get('https://www.zhihu.com/explore')
#### 获得cookies
print(browser.get_cookies())
#### 添加cookie
browser.add_cookie({'name': 'name', 'domain': 'www.zhihu.com', 'value': 'germey'})
print(browser.get_cookies())
#### 删除所有cookies
browser.delete_all_cookies()
print(browser.get_cookies())
</code></pre></div><p><br></p><h2>12、选项卡管理</h2><div class="highlight"><pre><code class="language-text"><span></span>import time
from selenium import webdriver

browser = webdriver.Chrome()
browser.get('https://www.baidu.com')
#### 打开一个选项卡
browser.execute_script('window.open()')
print(browser.window_handles)
#### 选择第二个选项卡
browser.switch_to_window(browser.window_handles[1])
browser.get('https://www.taobao.com')
time.sleep(1)
browser.switch_to_window(browser.window_handles[0])
browser.get('https://python.org')
</code></pre></div><p><br></p><h2>13、异常处理</h2><div class="highlight"><pre><code class="language-text"><span></span>from selenium import webdriver
from selenium.common.exceptions import TimeoutException, NoSuchElementException

browser = webdriver.Chrome()
try:
    browser.get('https://www.baidu.com')
except TimeoutException:
    print('Time Out')
try:
    browser.find_element_by_id('hello')
except NoSuchElementException:
    print('No Element')
finally:
    browser.close()
</code></pre></div><p><br></p><blockquote>作者：蒋蜀黍  Python爱好者社区专栏作者   授权原创发布，请勿转载，谢谢。<br>出处：<a href="http://link.zhihu.com/?target=http%3A//mp.weixin.qq.com/s/hYBdkE5IEYNZo4vwoyfT4Q" class=" wrap external" target="_blank" rel="nofollow noreferrer">Selenium 库学习笔记<i class="icon-external"></i></a>

## TensorFlow
#### Variable
必须用到:
    ```init = tf.initialize_all_variables() #初始化全部变量 
    
随后即可:
    ```sess.run(init)
## Tensorflow 笔记

這是在對照官網學習時的前期入門筆記，其實和官網基本沒有區別，好吧，真的沒有區別。因爲官網真的寫的太好了。
至於我爲什麼要寫出來，是因爲我之前寫在了紙上，對於邏輯的把握很給力，所以在寫一邊。

不過TensorFlow 變動真的很大，版本更迭也很快，所以，下方只是理清邏輯，具體的東西還是去官網比較好。只不過我這兒網謎之很難等上去… 

 總而言之一句話，先搭好架子再選擇填充材料。就是它的核心邏輯了。而改進也是在架子基礎上去優化優化器。嗯…現在理解就是這樣。

### 1
#### 导入
    import tensorflow as tf
步骤：①构建计算图          ②运行计算图

---

#### 2
##### Build a simple computational Graph
    node1 = tf.contant(3.0, dtype = tf.float32)
    node2 = tf.contant(4.0) #also tf.float32 impicitly
    print (node1, node2)
###### 输出为：
    Tensor ("Cast: 0", shape = (), dtype = float)
    Tensor ("Cast_1: 0", shape = (), dtype = float)
打印并不输出值3.0，4.0，而在评估时分别产生3.0和4.0节点。欲实际评估节点，We must run the computational graph within a session. A seesion encapsulation the control and state of the tensorflow runtime.

---

#### 3
##### Creates a session object , 然后调用``` run ```方法运行足够的computational graph to envlute node1 and node2
    sess = tf.Session()
    print (sess.run([node1, node2]))
###### 输出为：     
    [3.0,   4.0]        #可见预期值

---

#### 4
##### We can build more complicated computations by combining Tensor nodes with operations
    node3 = tf.add(node1, node2)
    print ("node3: ", node3)
    print ("sess.run(node3):", sess.run(node3))
###### 输出为：
    node3:  Tensor("Add:0", shape = (1,dtype = float32))
    sess.run(node3): 7.0

---

#### 5
##### 更进一步的，A graph can be parameterized. To accept external input , 称为```placeholders```
    a = tf.placeholder(tf.float32)
    b = tf.placeholder(tf.float32)
    adder_note = a + b      #provide a shortcut for tf.add(a, b) and can with multiple input by using
    print (sess.run(add_note, {a:3, b:4.5}))
    print (sess.run(add_note, {a:[1, 3],  b:[2, 4]}))
###### 输出为：
    7.5
    [3.  7.]
##### 5.1
##### more complex by adding anther aperation. for example:
    add_and_triple = adder_note * 3
    print (sess.run(add_and_triple, {a:3, b:4.5}))
###### 输出为：
    22.5
In ```TensorBoard```(Tensorflow圖形化界面): 图片.jpg        是下面```a+b```` 然后连接到```adder_node```  ,随后再连接到```y(add_and_triple)```
##### 5.2
##### That a model that can take arbitary inputs:To mode the modeel trainable,need to modify the graph to get new a outputs with the some input : ```Variables``` allow us:
    w = tf.Variables([  .3], dtype = tf.float32)
    b = tf.Variables([ -  .3], dtype = tf.float32)
    x = tf.placeholder(tf.float32)
    linear_model = w * x + b        #线性模型

---

#### 6
##### 使用```tf.constant``` :调用、初始化常数  用```tf.Vaiables``` :變量不被初始化，調用欲初始化所有變量，必須calll a special operation:
    init = tf.global_variables_initializer()
    sess.run(init)

---

#### 7
##### x is a placeholder, we can evaluate ```lnear_model``` for several values of x simultaneausly as follow:
    print (sess.run(linear_model, {x:[1,2,3,4]}))
###### 輸出爲：
    [0.        0.30000001   0.60000002  0.90000004]

---

#### 8 
##### 有以上結果並不知好壞，因此編寫損失函數：
    y = tf.placeholder(tf.float32)
    squared_deltas = tf.square(linear_model - y)        #平方（下方差和）
    loss = tf.reduce_sum(squred_deltas)     #差和（上方平方）
    print (sess.run)loss, {x:[1, 2, 3, 4], y:[0, -1, -2, -3]})
###### 輸出爲：
    23.66       #損失值：差平方和

##### 8.1
##### We could improve this manually W,b to perfact values of -1 and 1. A variable is initializef to the value provided to ```tf.Variable``` but can be charged using operation like ```tf.assign```
##### W = -1 and b = 1 are optimal parameters:(最優參數)
    fixW = tf.assign(W, [-1.  ])
    fixb = tf.assign(b,[1.  ])
    sess.run(fixW, fixb)
    print(sess.run(loss, {x:[1, 2, 3, 4],  y:[0, -1, -2, -3]}))
###### 輸出爲：
    0, 0  # The final print shows the loss now is zero !

---

#### 9
##### 模型保存与加载：
###### 保存：
    saver = tf.train.Saver()    # 生成saver
    with tf.Session() as sess:
    sess.run(tf.global_variables_initializer()) # 先对模型初始化

    # 然后将数据丢入模型进行训练blablabla

    # 训练完以后，使用saver.save 来保存
    saver.save(sess, "save_path/file_name") #file_name如果不存在的话，会自动创建
###### 加载：
    saver = tf.train.Saver()
    with tf.Session() as sess:  #参数可以进行初始化，也可不进行初始化。即使初始化了，初始化的值也会被restore的值给覆盖
    sess.run(tf.global_variables_initializer())
    saver.restore(sess, "save_path/file_name")  #会将已经保存的变量值resotre到 变量中。

---

#### 10
##### 图形化操作：
    >http://blog.csdn.net/u014595019/article/details/53912710
这篇写的还不错，等之后用过之后再写。


---

---

#### Variable
必须用到:
	```init = tf.initialize_all_variables()	#初始化全部变量 
	
随后即可:
	```sess.run(init)
## Tensorflow 笔记

這是在對照官網學習時的前期入門筆記，其實和官網基本沒有區別，好吧，真的沒有區別。因爲官網真的寫的太好了。
至於我爲什麼要寫出來，是因爲我之前寫在了紙上，對於邏輯的把握很給力，所以在寫一邊。

不過TensorFlow 變動真的很大，版本更迭也很快，所以，下方只是理清邏輯，具體的東西還是去官網比較好。只不過我這兒網謎之很難等上去… 

 總而言之一句話，先搭好架子再選擇填充材料。就是它的核心邏輯了。而改進也是在架子基礎上去優化優化器。嗯…現在理解就是這樣。

### 1
#### 导入
	import tensorflow as tf
步骤：①构建计算图	      	②运行计算图

---

#### 2
##### Build a simple computational Graph
	node1 = tf.contant(3.0, dtype = tf.float32)
	node2 = tf.contant(4.0)	#also tf.float32 impicitly
	print (node1, node2)
###### 输出为：
	Tensor ("Cast: 0", shape = (), dtype = float)
	Tensor ("Cast_1: 0", shape = (), dtype = float)
打印并不输出值3.0，4.0，而在评估时分别产生3.0和4.0节点。欲实际评估节点，We must run the computational graph within a session. A seesion encapsulation the control and state of the tensorflow runtime.

---

#### 3
##### Creates a session object , 然后调用``` run ```方法运行足够的computational graph to envlute node1 and node2
	sess = tf.Session()
	print (sess.run([node1, node2]))
###### 输出为：  	
	[3.0,   4.0]		#可见预期值

---

#### 4
##### We can build more complicated computations by combining Tensor nodes with operations
	node3 = tf.add(node1, node2)
	print ("node3: ", node3)
	print ("sess.run(node3):", sess.run(node3))
###### 输出为：
	node3:  Tensor("Add:0", shape = (1,dtype = float32))
	sess.run(node3): 7.0

---

#### 5
##### 更进一步的，A graph can be parameterized. To accept external input , 称为```placeholders```
	a = tf.placeholder(tf.float32)
	b = tf.placeholder(tf.float32)
	adder_note = a + b		#provide a shortcut for tf.add(a, b) and can with multiple input by using
	print (sess.run(add_note, {a:3, b:4.5}))
	print (sess.run(add_note, {a:[1, 3],  b:[2, 4]}))
###### 输出为：
	7.5
	[3.  7.]
##### 5.1
##### more complex by adding anther aperation. for example:
	add_and_triple = adder_note * 3
	print (sess.run(add_and_triple, {a:3, b:4.5}))
###### 输出为：
	22.5
In ```TensorBoard```(Tensorflow圖形化界面): 图片.jpg		是下面```a+b```` 然后连接到```adder_node```  ,随后再连接到```y(add_and_triple)```
##### 5.2
##### That a model that can take arbitary inputs:To mode the modeel trainable,need to modify the graph to get new a outputs with the some input : ```Variables``` allow us:
	w = tf.Variables([  .3], dtype = tf.float32)
	b = tf.Variables([ -  .3], dtype = tf.float32)
	x = tf.placeholder(tf.float32)
	linear_model = w * x + b		#线性模型

---

#### 6
##### 使用```tf.constant``` :调用、初始化常数  用```tf.Vaiables``` :變量不被初始化，調用欲初始化所有變量，必須calll a special operation:
	init = tf.global_variables_initializer()
	sess.run(init)

---

#### 7
##### x is a placeholder, we can evaluate ```lnear_model``` for several values of x simultaneausly as follow:
	print (sess.run(linear_model, {x:[1,2,3,4]}))
###### 輸出爲：
	[0.        0.30000001   0.60000002  0.90000004]

---

#### 8 
##### 有以上結果並不知好壞，因此編寫損失函數：
	y = tf.placeholder(tf.float32)
	squared_deltas = tf.square(linear_model - y)		#平方（下方差和）
	loss = tf.reduce_sum(squred_deltas)		#差和（上方平方）
	print (sess.run)loss, {x:[1, 2, 3, 4], y:[0, -1, -2, -3]})
###### 輸出爲：
	23.66		#損失值：差平方和

##### 8.1
##### We could improve this manually W,b to perfact values of -1 and 1. A variable is initializef to the value provided to ```tf.Variable``` but can be charged using operation like ```tf.assign```
##### W = -1 and b = 1 are optimal parameters:(最優參數)
	fixW = tf.assign(W, [-1.  ])
	fixb = tf.assign(b,[1.  ])
	sess.run(fixW, fixb)
	print(sess.run(loss, {x:[1, 2, 3, 4],  y:[0, -1, -2, -3]}))
###### 輸出爲：
	0, 0  # The final print shows the loss now is zero !

---

#### 9
##### 模型保存与加载：
###### 保存：
	saver = tf.train.Saver()	# 生成saver
	with tf.Session() as sess:
	sess.run(tf.global_variables_initializer())	# 先对模型初始化

	# 然后将数据丢入模型进行训练blablabla

	# 训练完以后，使用saver.save 来保存
	saver.save(sess, "save_path/file_name")	#file_name如果不存在的话，会自动创建
###### 加载：
	saver = tf.train.Saver()
	with tf.Session() as sess:	#参数可以进行初始化，也可不进行初始化。即使初始化了，初始化的值也会被restore的值给覆盖
	sess.run(tf.global_variables_initializer())
	saver.restore(sess, "save_path/file_name")	#会将已经保存的变量值resotre到 变量中。

---

#### 10
##### 图形化操作：
	<http://blog.csdn.net/u014595019/article/details/53912710>
这篇写的还不错，等之后用过之后再写。
