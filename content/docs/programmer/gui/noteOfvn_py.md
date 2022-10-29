---
title: Vn.Py学习笔记（Python交易平台框架）
date: 2018-05-15 10:13:48
categories: [note, python, learning]
tags: [Vn.Py, gui, socket, learning]
---
author: Ian

# Vn.Py笔记 ✏📔

![vn.py](https://static.vnpy.com/static/img/index/2019-5-27/mainwindow.PNG)
---

<font color=green>一个开源Python交易软件，主使用CTP协议。当然，还有其他协议了其源项目在<http://www.vnpy.org/> </font>

***

---

---

## 初期笔记
    报单交易过程中，

    CTP使用BrokerID 从业务层面完全隔离不同经纪公司的交易、风控及结算用户的接入。
    BrokerID具体取值咨询开户的经纪公司。

CTP中 UserID为操作员代码，InversterID为投资者代码； 投资者自己下单两者同为投资者代码
    
    CTP-API中，OrderRef和OrderAction    前者为CTP后台提供给客户端标识一笔报
    单的字段，从客户端可通过（FrontID、SessionID、OrderRef）唯一确定一笔报
    单；；；后者与OrderRef功能相似，提供给客户端来标识一笔撤单。
    前者的数据类型为字符数组，必须为阿拉伯数字字符。
    OrderRef（OrderActionRef）取值必须保证在同一会话内发送的报单
    OrderRef（OrderActionRef）值大于之前的最大值，开发多线程客户端尤为需要  
    注意。
    
CTP-API库：

    error.dtd\error.xml 错误定义文件    ----   ThostFrfcMdApi.h 
    交易接口类定义文件  
    ———   ThostFtfcUserApiDataType.h 类型定义文件  ------    
    thostmduserapi.lib,thostmduserpi.dll 行情接口库文件     -----   
    thosttraderapi.lib,thosttraderapi.dll交易接口库文件   ----- 
    
    交易和行情接口类定义文件都包含API 和 SPI类定义，客户端使用API向CTP后台
    发送请求，CTP后台则使用SPI向客户端回传响应及回报

    行情Demo开发：
        1.将API文件复制到工程目录；并将所有的头文件和静态、动态库连链接库
    并将文件导入到项目工程中。
        先继承行情接口类CThostFtdcMdspi，并实现需要实现的虚函数。  
    OnFrontConnectde、OnFrontDisconnected、OnPspUserLogin、
    OnRspSubMarketDAta


/**********API工作流程*************/

API压缩包——API含常量对应字符、类型定义、操作系统编译定义、回调函数（MdSpi）（柜台向用户端发送信息后被系统自动调用的函数）、主动函数（MdApi）（向柜台发送各种请求和指令）

API工作流程：
    创建MdSpi对象（回掉函数），调用MdApi类，以Create开头的静态方法，创建MdApi对象（主动函数），注册MdSpi对象指针，行情柜台前置机地址，调用MdApi对象Init方法初始化连接前置机，连接成功会通过OnFrontConnected回调通知用户，用户获得连接成功通知后，调MdApi的ReqUserLogin登陆，登陆后MdSpi的OnRsqUserLogin通知用户
----------------------到此登陆完成---------------------

    MdApi：（行情相关）
        使用MdApi对象的SubscribeMarketData方法，传入参数为想要订阅的“合约
    代码”，订阅成功当合约有新行情通过MdApi的OnRtnDepthMarketData回调通知   
    用户
----------------------至此订阅完成---------------------
        当用户的某次请求发生错误时，会通过OnRspError通知用户        MdApi也含有退订合约、登出功能。      而一般退出程序则直接杀进程（不太安全便是）

    TraderApi：（交易相关）
        不同于以上的有 注册TraderSpi对象的指针后需要调用TraderApi对象的
    SubscribePrivateTopic和SubscribePublicTopic方法去选择公开和私有数据流的重
    传方法
        对于期货柜台，每一日第一次登陆需要先查询前一日的结算单，等待查询
    结果返回，确认，才可进行后续操作（CTP、恒生UFT），证券（LTS）无此要求
        上一步完成后，用户可以调用ReqQryInstrument的方法查询柜台上所有可
    以交易的合约信息（包括代码、中文名、涨跌停、最小价位变动、合约乘数等大
    量细节），一般是在这里获得合约信息列表后，再去MdApi中订阅合约；经常有
    人问为什么在MdApi中找不到查询可供订阅的合约代码的函数，这里尤其要注
    意，必须通过TraderApi来获取
        当用户报单、成交状态发生变化时，TraderApi会自动通过OnRtnOrder、
    OnRtnTrade通知，无需额外订阅


/************封装API****************/
    封装后API的动作：
        主动函数：  调用封装API主动函数，传入Python变量作为参数—>封装API将Python变量转换成C++变量—>API调用原生API主动函数传入C++变量作为参数
        回掉函数：  交易柜台通过原生API传入参数为C++变量->封装API将C++变量转换为Python变量->封装API调用封装后的回调函数想Python程序中推送数

    封装处理：
        将回调函数Spi类和主动函数Api类封装为一个类，使用中更加方便
        在API中包含一个缓冲队列，当回调函数收到新的数据信息时只是简单存入
    并立即返回，而数据信息的处理和向Python中的推送则由另一个工作线程执行
        鉴于Python中dict字典内的键和值的类型可以不同，所以利用此来代替
    C++的结构体


    处理示例：
        getChar()： d(Python字典对象) key(d中想要提取的数据键名) 
    if(d.has_key(key)) 判断是否存在这个键；
        object o = d[key]; 提取对应值   
        extract<string> x(o); 生成提取
    std::string类的提取器
        if (x.check())  检测能否提取出数据  string s = x();  执行解包器，提取
    string对象
        const char *buffer = s.c_str();  从s中获取字符串指针bufffer     
    strcpy_s(value, strlen(buffer) + 1, buffer);  
    将字符串指针指向的字符串数组复制到结构体成员的指针上    对字符串指针赋值
    必须使用strcpy_s, vs2013使用strcpy
    编译通不过+1应该是因为C++字符串的结尾符号？不是特别确定，不加这个
    1会出错
            
/**************事件驱动*****************/

时间驱动： 定时调用 
事件驱动： 新事件被推送时（如新行情、成交）则调用
    初始化：    事件队列、引擎开关（标志）、事件线程、定时器、一个事件和处理函数对应字典（__handlers）
    引擎运行：  循环检查引擎开关 若开则一直尝试获取事件（阻塞开，时间1s），处理事件； 若出错则pass
    处理事件：  检测是否有对当前事件监听的处理函数，若有则循环调用相应处理函数对事件进行处理
    计时器事件：    创建计时器事件，推入计时器事件
    引擎启动：  打开引擎开关、启动事件处理线程、启动定时器（事件默认间隔1s）
    停止引擎：  关闭。。。。、停止计时器、等待事件处理线程退出
    注册事件处理：  尝试获取对应处理此类型函数列表（对应字典），若无则创建。
    注销函数监听：  。。。。。。。。。。。。。。。。。。。。。，若无则pass，若函数存在于列表则将之移除，若函数列表为空，则引擎中移除该事件类型
    put：       向事件队列中存入事件

底层接口对接：
    交易程序架构分：底层接口、中层引擎、顶层GUI，
    为将某API对接到程序中需：1.将API的回调函数收到的数据—>中层引擎 等待处理 2.将API的主动函数进行一定的简化封装，便于中层引擎调用



中层引擎设计：
    进一步封装底层接口所暴露出的API函数，使得其更容易被上层的GUI和策略组件调用。
    构造函数：
        以主引擎成员变量形式创建事件驱动引擎ee，行情接口md和交易接口td的对象。
        随后立即启动，当用户调用接口连接、登陆等功能、收到事件推送，ee可以立即推送到监听这些事件的组件进行处理。
        LTS和CTP接口的持仓情况和账户情况不通过推送，需手动查询。Demo选择循环查询模式，不断更新。可选择不进行查询，降低占用网络带宽。
        登陆成功后，查询柜台所有可交易信息，保存到dictInstrument字典中，方便后续查询
    优化了一些函数方法的调用方式，将经纪商一起提供的接口登陆封装在一个函数中，减少了重复书写的次数。

---

---

---

---

## 引擎之间执行过程

### 发单为例：
设置发单按钮 -> 将点按动作关联sendOrder发单实现函数（从输入框获取合约代码->获取合约信息对象（见下） -> *如果成功获取* -> 再获取方向价格等信息 -> 调用主引擎下发单实现 -> 主引擎转到TdApi下发单函数执行（请求编号（API管理） -> 将传入信息数据存入字典（合约代码、方向价格等） -> 报单编号（API管理） -> 用户id、单子属性（投机、立即发单、今日有效）等信息存入字典） -> self.reqOrderInsert(req（信息字典）, self.__reqid（请求编号）) -> 返回订单号（报单编号））

***

#### 主引擎：（负责对API的调度）
__init__()初始化中的动作：
    创建事件驱动引擎、创建API接口、启动事件驱动引擎、循环查询持仓和账户相关（之后学习）、创建合约存储空字典，注册插入合约对象执行函数事件类型和其处理函数。
其中包含几乎所有的功能函数，包含了每个功能函数的实现方法

#### 事件驱动引擎：
__init__()初始化中的动作：
    创建事件队列、创建设置事件引擎开关（关）、创建事件处理线程(目标为引擎运行)、创建计时器（将超时动作连接到\__onTimer函数）、创建\__handlers空字典（存储对应事件调用关系）
统筹管理事件的执行，在其中建立起事件执行队列管理向队列中插入事件，分配事件对象类型（据此注册其执行函数）和具体事件数据（时间及日志），拥有注册事件处理监听及注销监听。最终使得整个程序有序的进行。

***

### 调用关系
主引擎在初始化时即启动事件驱动引擎（调用启动函数start()（将引擎开关设为启动、启动事件处理线程、启动计时器）） -> 事件处理线程运行目标\__run()（若开关开则将从**事件队列**中get()到事件，放到处理函数\__process()中执行） -> \__process()处理事件函数（检查事件类型，在\__handlers字典中是否有对此监听处理函数，若存在则调用字典中处理函数）

    事件启动引擎start()中启动定时器 -> 创建计时器事件 -> 向队列存入计时器事件

***

#### 获取合约信息对象：
从合约字典中读取合约信息对象有则继续执行原本程序操作（获取名称、发单撤单），无则None


##### 以初始化查询为例：
主引擎初始化中注册`self.ee.register(EVENT_TDLOGIN, self.initGet)`,`EVENT_TDLOGIN`为交易服务器登陆成功事件。即此事件为登录成功后开始初始化查询。
步骤：打开设定文件`setting.vn`，尝试读取设定字典。载入后，设定事件类型、将事件推入事件队列、查询投资者、循环查询账户和持仓。（若不存在or合约数据非今天，则发出获取合约请求。）-> 获取合约 -> 定义事件类型 -> 推入事件队列 -> API查询合约

---

---

## ctpGateway 接入方法
<font color=orange>考虑到现阶段大部分CTP中的ExchangeID字段返回的都是空值
vtSymbol直接使用symbol</font>

---

创建CTP价格方向交易所持仓产品等类型映射，方便调用  **然后**  `class CtpGateway(VtGateway):`CTP接口中初始化动作（继承VtGateway实例化事件引擎、设定网关名称为’CTP‘、实例化ctpMdApi，ctpTdApi、初始化行情交易连接状态，循环查询允许）

**连接过程**
初始化账号密码等、连接服务器、注册服务器地址、登陆    
订阅合约里有个设计为：尚未登陆就调用了订阅则保存订阅信号，则在成功登陆之后的登陆回报函数中重新订阅

---

## 数据记录器

#### drBase.py中（定义数据类型）：（<font color=orange>数据记录器和CTA两模块共同使用</font>）
    K线数据
        构造函数（定义数据类型）：vt系统代码、合约代码、交易所代码、开高低
    关、bar开始时间、时间、成交量持仓量
    Tick数据
        构造函数（定义数据类型）：vt系统代码、合约代码、交易所代码、成交数
    据、tick时间、五档行情

---

#### <font color=red>DrEngine数据记录引擎</font>
获取当前文件绝对路径

    settingFileName = 'DR_setting.json'
    path = os.path.abspath(os.path.dirname(__file__))       
    settingFileName = os.path.join(path, settingFileName)
初始化中动作：实例化设置主引擎、事件引擎、获取当前日期、创建主力合约代码映射字典、Tick对象字典、K线对象字典、初始化数据库插入单独线程、载入设置，订阅行情 

##### 载入设置、订阅行情
打开`DR_setting.json`文件，以json载入，其中`’working‘`决定是否启动行情记录功能。随后从json文件中循环获取合约代码订阅tick和bar

启动数据插入线程（`run`函数（向MongoDB中插入数据））、注册事件监听（`procecssTickEvent`处理行情推送（<font color=green>下详</font>））

##### 处理行情推送
从事件字典中取出保存的具体事件数据、`vtSymbol`为tick识别信号（合约代码）、转化Tick格式、更新TIck数据（并发出日志）、更新分钟线数据

---

## 风控模块
从配置json文件中读取设定信息  操作运作：1.检测风控设定值变化 2.每笔交易发单时使用风控模块决定该次发单是否允许   （其中流控计数在每次调用风控检测时计数、成交合约量在更新成交数据中加交易数值）

---

---

---

## CTA策略

直接来到改版之后：
    

---

---

---

## CTP交易托管API
### 介绍
基于C++的类库，通过使用提供接口实现相关交易功能，含：报单与报价录入、的撤销、的挂起、的激活、的修改、的查询、成交单查询、投资者查询、 投资者持仓查询、合约查询、交易日获取等

含文件：交易接口、API所需数据类型、业务相关数据结构i、的头文件、动态链接库、导入库

### 体系结构
建立在TCP协议之上FTD协议与交易托管系统进行通讯
**FTD通讯模式：** 

|               |                               |   
|   :---            |               ---:                |
|  对话通讯模式 |   - 会员端请求、接收处理、响应    |   
|  私有通讯模式 |   - 交易所主动向特定会员发出      |   
|  广播通讯模式 |   - 交易所主动、全员发送          |   



### 接口模式
`CThostFtdeTraderApi`和`CThostFtdeTraderSpi`，前者发送请求，后者回调响应。旗下函数方法前者以Req开头后者以OnRsp开头。请求接口第一个参数为请求的内容，不能为空。第二个参数为请求号。

如果接收到的响应数据不止一个，则回调函数会被多次调用。第一个参数为响应的具体数据，第二个参数为处理结果，第三个参数为请求号，第四个参数为响应结束标志，表明是否是本次响应的最后一次回调。

### 运行模式
至少两个线程，一个为应用程序主线程，一个为交易员API工作线程，其间通讯由API工作线程驱动。

### 撤单 发单
#### 发单为例：
在用户点击发单之后，程序从“交易”栏的`text()`获取合约代码，随后从详细合约保存字典中读取其他信息，将之保存到一个字典中之后，调用主引擎对特定接口发单。

发单完成之后，马上会收到报单响应 OnRspOrderInsert，说明交易系统已经收到报单。报单进入交易系统后，如果报单的交易状态发生变化，就会收到报单回报 OnRtnOrder。如果报单被撮(部分)成交，就会收到成交回报 OnRtnTrade。通过更新


#### 撤单时：
程序从单元格中获取exchange、frontID、orderID、sessionID、symbol、gatewayName等信息，调用主引擎对特定接口撤单。撤单时调用Api函数为reqOrderAction其内容包括撤销、挂起、激活、修改，故还需一个Flag参数

ps：如果报单还停留在 Thost，Thost 可以用 Front 、SessionID、OrderRef 来定位
如果报单停留在交易所，Thost 可以用 ExchangID、OrderSysID 来定位，然后向交易
所转发撤单指令。

### TraderApi所有方法功能
    OnFrontConnected/Disconnected       
    # 客户端与交易托管系统建立起通信连接时
    OnHeartBeatWarning      
    # 当长时间未收到报文时
    OnRspUserLogin/Logout       
    # 登陆注销响应
    OnRspUserPasswordUpdate     
    # 改密响应
    OnRspTradingAccountPasswordUpdate       
    # 当客户端发出资金账户口令更新指令后，交易托管系统返回响应时
    OnRspError      
    # 请求出错时
    OnRspOrderInsert        
    # 报单录入
    OnRspOrderAction        
    # 报单操作包括报单的撤销、报单的挂起、报单的激活、报单的修改。当客户端
        发出过报单操作指令后，交易托管系统返回响应时
    OnRspQueryMaxOrderVolume        
    # 查询最大报单
    OnRspSettlementInfoConfirm      
    # 当客户端发出投资者结算结果确认指令后，交易托管系统返回响应时
    
    等……  lol 统计无力
？

---

---

---

## CTA 策略引擎

##### \__init__()的工作：

* 加载主引擎、事件引擎；获取当前日期
* 设定是否在回测
* 保存策略实例的字典strategyDict(key为策略名称，value为策略实例)、
* 保存vtSymbol和策略实例映射的字典(用于推送tick数据，可能多个策略交易同一个vtSymbol因此key为vtSymbol.value为包含所有相关策略对象的list)、
* 保存vtOrderID和strategy对象映射的字典(用于推送order和trade数据key为vtOrderID，value为strategy对象）、
* 本地停止单编号计数、本地停止单字典(key为stopOrderID，value为stopOrder对象)、
* 持仓缓存字典(key为vtSymbol，value为PositionBuffer对象)、
* 成交号集合、
* 设置引擎类型为实盘、
* 注册事件监听


#### 初始化策略
从数据库中读取3天的历史TICK数据、行情更新。。。。。有的话待续

#### 启动策略
从策略实例字典中取出策略实例，调用策略函数（已经初始化，没有在进行策略交易），开启进行交易标志位。

#### 停止策略
从策略实例字典中取出策略实例，调用策略函数（            在进行策略交易），关闭策略交易标志位 -> 对该策略发出的所有限价单进行撤单 -> 发出的所有本地停止单撤单 -> 

#### 保存、读取策略配置


触发策略状态变化事件（通常用于通知GUI更新）
获取策略的参数字典
获取策略当前的变量字典


### 记录
报单更新、成交更新都是先检测是否有对此监听的策略
限价单成交处理：成交回报、报单回报、记录成交到列表、删除该限价单

#### 基础功能的策略调用
策略中发单时，需要在设置参数时考虑设置。    另获取持仓缓存数据，做平昨平今的选择。
策略中发单时，检查报单是否有效，赋参，撤单。
发停止单，编号，赋参，保存至字典
撤停止单，从工作停止单字典中移除

---


#### Ta-Lib
趋势策略分为以下部分：
* 趋势信号（通常是基于某几个参数计算出来的指标值超过某个阈值）、
* 信号过滤（和趋势信号类似）、
* 出场方案（固定点数/百分比的止盈和止损，移动止损）。
所以，Ta-lib是策略实现工具罢了。

此库中提供了多种技术分析的函数，有多种指标：ADX、MACD、RSI、布林轨道等
；K线形态识别，如“黄昏之星”、“锤形线”等。

依靠此库对数据的分析，来下达发单撤单的动作即为策略。

###### 策略示例：
    基于Talib模块的双指数均线策略`class TalibDoubleSmaDemo(CtaTemplate):`
<font color=green>就是两个指标的数据来判断当前局势罢了</font>
1. 设定策略参数
2. 策略变量
3. 参数列表（保存参数名称）
4. 变量列表（保存变量名称）


###### 步骤
初始化策略（加载Bar数据）、启动策略、停止策略、收到行情Tick推送（计算K线）、收到Bar推送（缓存最新收盘价到列表 -> 数量足够后转化为Numpy数组后传入talib函数SMA中计算 -> 读取当前K线和上一根K线数值，用于判断均线交叉 -> 检测持仓状态，做出相应交易动作）

---

### CTA回测
##### \__init__()的工作
* 本地停止单编号计数    `self.stopOrderCount`
* 本地停止单字典    `self.stopOrderDict` And `self.workingStopOrderDict`
* 设引擎类型为回测
* 回测相关变量定义
* 当前最新数据，用于模拟成交使用

#### 运行回测
1. 载入历史数据
2. 根据回测模式确定要使用数据类
3. 初始化策略
4. 启动策略
5. 回放数据（从数据库中取得推到newBar或者newTick）

6. 策略获得新数据，执行相应操作


##### 基于最新数据撮合限价单
先确定会撮合成交的价格 -> 遍历限价单字典中所有限价单 -> 判断是否会成交 -> 发生成交推送成交数据（买入 -> 增加持仓 推送委托数据、从字典中删除该限价单）

#### 计算原理
    

---

---

---

# 改版之后程序架构
|   |   |       |   |       |       |   |       |       |       |   |   |
|:----  |---    |   --- |   |---        |---        |----   |   --- |   --- |   --- |---    |---:   |
|   |APIs   |       |***    |       |   |   |       |   Trader  |       |   |   |
|`CTP`      |   |`KSGold`   |***    |`Common`   |`Condig`   |`Core`|`Gateway`   |`Setting`  |`Strategy` |`UI`   |`main`|
|CtpMdApi、CtpTdApi | ………… | ………… |Md、Td| ……………… | ……………… |CTA、HTA、引擎、事件管理| ……………… |配置文件| ……………… | ……………… | ……………… |


## 事件引擎
两版都一样，作为一个程序运行最外层的生成的实例，来进行各个实例之间的数据传输。因为每个实例都将数据在事件引擎中保存，调用事件引擎中的事件队列来对进行事件运行安排。


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

B与C分别在去改变读取在A中定义的数值。  嗯，没错，这么看的画确实时Python基础……所以没有这个基础的我看起来前期还挺费劲。当然，理解很好理解，就是在实现方法上不知原理的话就很难过。最主要的是，知道了原理在自己编写的时候可以的心用手，信手拈来。嗯~ o(*￣▽￣*)o就是这么写意和惬意。<font color=indigo>Indigo</font>色在纯黑背景下不好辨识哈哈，还是换少女粉吧

---

---

---


# Vn.Py 界面

Icon 图标下载网:    <http://www.easyicon.net/>
## 界面设计文档
### 功能要求
连接、登陆，订阅，发撤单，持仓、账户信息、成交（下单时间、成交时间、备注（下单动作者））、保留交易模块、跟随鼠标点击更新交易模块中单子内容


### 文档编写步骤
由需求确定功能，划分模块，模块关系，下分框架，框架实现

---

---

### 模块
工具栏、行情显示、策略池、账户持仓、消息栏

#### 工具栏
连接（含各个端口） 风控、帮助、登陆状态显示

##### 工具功能

|工具名称   |       说明        |   备注        |
|:----      |       :----:      |    ----:      |
|连接   |弹出端口列表       | 通过复选框选中对应端口    |
|风控   |弹出设定列表       | 通过文本框输入设定数值    |
|帮助   |弹出帮助窗口       |       |

#### 策略池

|   操作位置        |      热点操作 |           |
|:----              |   :----:          |    ----:  |
| 策略名称单元格    | 鼠标指针悬停      | 展开操作界面  |
| 动作按钮      | 鼠标单击      | 执行选中  |
| 动作按钮      | 鼠标右击      | 展开操作界面  |

#### 消息栏
分“成交”、“错误”、“日志”三个模块，选择相应模块显示对应内容

| 日志              | 错误                          | 成交      |
|:----                  |:----:                         |    :----:     |
| 时间、内容、接口      |时间、错误代码、错误信息、接口     | 成交编号、委托编号、合约代码、名称、方向、开平、价格、成交量、成交时间、接口      |
| 显示操作日志          | 显示当前操作错误信息              | 显示成交单信息        |


#### 账户持仓信息
账户显示账户信息，并具备切换账户功能
当前选中账户 显示在旁label中。

### 界面切换






# 记录笔记

照例，先贴网址： <http://www.qaulau.com/books/PyQt4_Tutorial/index.html>
#### 窗口设置
    resize(8, 8)
    setWindowTitle(u'标题')
#### 获取图标
    def getIcon(filename):
    """ 获取图标 """
        fileInfo = Qt.QFileInfo(filename) 
        fileIcon = Qt.QFileIconProvider() 
        icon = QtGui.QIcon(fileIcon.icon(fileInfo)) 
        return icon  
    使用时：
    self.setWindowIcon(getIcon('../hi/app.ico'))

---

##### Dock
    widgetTestM, dockTestM = self.createDock(AllMarketMonitor, vtText.“dock
    标题”, QtCore.Qt.RightDockWidgetArea)
    # 方向有：  
    RightDockWidgetArea,BottomDockWidgetArea,LeftDockWidgetArea
    # 创建dock窗口
    # 可利用
    self.tabifyDockWidget(dockMarketM, dockAllDataM)
    来合并同一个方向上的dock
    
    # 此下还没看… 
    dockTradeM.raise_()
    dockPositionM.raise_()
    
    # 连接组件之间的信号
    widgetPositionM.itemDoubleClicked.connect(widgetTradingW.closePosition)
        
    # 保存默认设置
    self.saveWindowSettings('default')

其实现函数为：
"""创建停靠组件"""

    def createDock(self, widgetClass, widgetName, widgetArea):
        widget = widgetClass(self.mainEngine, self.eventEngine) 
        dock = QtGui.QDockWidget(widgetName)
        dock.setWidget(widget)
        dock.setObjectName(widgetName)
        dock.setFeatures(dock.DockWidgetFloatable|dock.DockWidgetMovable)
        self.addDockWidget(widgetArea, dock)
        return widget, dock
> 再本质一点的东西为：

    widget1 = Ha(self)
    dock = QtGui.QDockWidget('haha')
    dock.setObjectName('ha1')
    dock.setWidget(widget1)
    dock.setFeatures(dock.DockWidgetFloatable | dock.DockWidgetMovable)
    self.addDockWidget(QtCore.Qt.BottomDockWidgetArea, dock)

#### 动作
    exit = QtGui.QAction(QtGui.QIcon('hello.ico'), 'exit', self)
    exit.setShortcut('Ctrl+Q')
    exit.setStatusTip('Exit application')
    # 图标、文字、快捷键、提示信息
    
    menubar = self.menuBar()
    file = menubar.addMenu('&File')
    file.addAction(exit)
    # 创建目录和工具栏，将动作添加进去。工具栏同理

### 定位布局
#### 绝对定位
    label1 = QtGui.QLabel(u'绝对定位', self)
    label1.move(15, 60)
    # 创建、移动到显示位置

#### 框布局 及 布局元素平均分布
    okButton = QtGui.QPushButton("OK")
    cancelButton = QtGui.QPushButton("Cancel")
    # 创建按钮

    hbox = QtGui.QHBoxLayout()
    hbox.addStretch(1)
    hbox.addWidget(okButton)        # 增加组件
    hbox.addWidget(cancelButton)
    # 创建水平栏
    hbox.addStretch()   # 平均分布
    
    vbox = QtGui.QVBoxLayout()
    vbox.addStretch(1)
    # 创建竖列

    vbox.addLayout(hbox)
    # 将水平栏插入竖列
    self.setLayout(vbox)     
    # 显示最终竖列
注意一下add时选择对类型就好了。

#### 组件之间连接信号
    # classA(QtGui.QTableWidget):
    #   pass
    classA.itemDoubleClicked.connect(classB.actionFunction)
    # 这样单纯调用还是可以的，但是数据传输… 就得继续研究一下了。

#### 调用Windows程序
    import win32api
        path = 'D:/vnpy-    \
        master/docker/dockerTrader/gateway/ctpGateway/CTP_connect.json'
        win32api.ShellExecute(0, 'open', 'notepad.exe', path, '', 1)
    # 使用记事本打开此文件

#### Json
    with open('D:/vnpy- \
        master/docker/dockerTrader/gateway/ctpGateway/CTP_connect.json',
    'r') as f:
    setting = json.load(f)
    self.userID = str(setting['userID'])
    self.password = str(setting['password'])

##### 关闭事件退出提示
    def closeEvent(self, event):
        reply = QtGui.QMessageBox.question(self, 'Message',"Are you 
    sure to quit?", QtGui.QMessageBox.Yes, QtGui.QMessageBox.No)
    if reply == QtGui.QMessageBox.Yes:
        event.accept()
    else:
        event.ignore()
函数放置位置就是主窗口类下就好。

##### VS2015 快捷键
    Ctrl + k    Ctrl + c        # 多行注释
    Ctrl + k    Ctrl + u        # 多行取消注释
##### 鼠标事件
press
move
release
doubleClick
clicked()
enterEvent 鼠标移入
leaveEvent 鼠标移出
回去看看具体函数

## 信号槽（传输额外参数）
一般来说，比如一个按钮吧。 在链接点击信号与槽时`buttonInit[i].clicked.connect(partial(self.init, i))`就完事了。然而，当循环创建按钮，对应同样的槽函数，只是需要执行的变量有区别时，就需要传输额外的参数。
这时，方法有二：

环境：

python2.7.8

pyqt 4.11.1
### 一： 使用lambda表达式
<pre class="prettyprint"><code class="language-python hljs "><span class="hljs-keyword">from</span> PyQt4.QtCore <span class="hljs-keyword">import</span> *  
<span class="hljs-keyword">from</span> PyQt4.QtGui <span class="hljs-keyword">import</span> *  

<span class="hljs-class"><span class="hljs-keyword">class</span> <span class="hljs-title">MyForm</span><span class="hljs-params">(QMainWindow)</span>:</span>  
    <span class="hljs-function"><span class="hljs-keyword">def</span> <span class="hljs-title">__init__</span><span class="hljs-params">(self, parent=None)</span>:</span>  
        super(MyForm, self).__init__(parent)  
        button1 = QPushButton(<span class="hljs-string">'Button 1'</span>)  
        button2 = QPushButton(<span class="hljs-string">'Button 1'</span>)  
        button1.clicked.connect(<span class="hljs-keyword">lambda</span>: self.on_button(<span class="hljs-number">1</span>))  
        button2.clicked.connect(<span class="hljs-keyword">lambda</span>: self.on_button(<span class="hljs-number">2</span>))  

        layout = QHBoxLayout()  
        layout.addWidget(button1)  
        layout.addWidget(button2)  

        main_frame = QWidget()  
        main_frame.setLayout(layout)  

        self.setCentralWidget(main_frame)  

    <span class="hljs-function"><span class="hljs-keyword">def</span> <span class="hljs-title">on_button</span><span class="hljs-params">(self, n)</span>:</span>  
        print(<span class="hljs-string">'Button {0} clicked'</span>.format(n))  

<span class="hljs-keyword">if</span> __name__ == <span class="hljs-string">"__main__"</span>:  
    <span class="hljs-keyword">import</span> sys  
    app = QApplication(sys.argv)  
    form = MyForm()  
    form.show()  
    app.exec_()  </code></pre>

<p>解释一下，on_button是怎样处理从两个按钮传来的信号。我们使用lambda传递按钮数字给槽，也可以传递任何其他东西—甚至是按钮组件本身（假如，槽打算把传递信号的按钮修改为不可用）</p>

### 二： 使用functools里的partial函数
<pre class="prettyprint"><code class="language-python hljs ">button1.clicked.connect(partial(self.on_button, <span class="hljs-number">1</span>))  
button2.clicked.connect(partial(self.on_button, <span class="hljs-number">2</span>))  </code></pre>

<p>《Rapid GUI Program with Python and QT》 P143例子。</p>

<pre class="prettyprint"><code class="language-python hljs "><span class="hljs-keyword">from</span> PyQt4.QtCore <span class="hljs-keyword">import</span> *  
<span class="hljs-keyword">from</span> PyQt4.QtGui <span class="hljs-keyword">import</span> *  
<span class="hljs-keyword">from</span> functools <span class="hljs-keyword">import</span> partial  
<span class="hljs-keyword">import</span> sys  

<span class="hljs-class"><span class="hljs-keyword">class</span> <span class="hljs-title">Bu1</span><span class="hljs-params">(QWidget)</span>:</span>  

    <span class="hljs-function"><span class="hljs-keyword">def</span> <span class="hljs-title">__init__</span><span class="hljs-params">(self, parent=None)</span>:</span>  
        super(Bu1, self).__init__(parent)  
        <span class="hljs-comment">#水平盒式布局  </span>
        layout = QHBoxLayout()  
        <span class="hljs-comment">#显示  </span>
        self.lbl = QLabel(<span class="hljs-string">'no button is pressed'</span>)  
        <span class="hljs-comment">#循环5个按钮  </span>
        <span class="hljs-keyword">for</span> i <span class="hljs-keyword">in</span> range(<span class="hljs-number">5</span>):  
            but = QPushButton(str(i))  
            layout.addWidget(but)  
            <span class="hljs-comment">#信号和槽连接  </span>
            but.clicked.connect(self.cliked)  

        <span class="hljs-comment">#使用封装，lambda  </span>
        but = QPushButton(<span class="hljs-string">'5'</span>)  
        layout.addWidget(but)  
        but.clicked.connect(<span class="hljs-keyword">lambda</span>: self.on_click(<span class="hljs-string">'5'</span>))  
        <span class="hljs-comment">#使用个who变量，结果不正常，显示 False is pressed  </span>
        <span class="hljs-comment">#but.clicked.connect(lambda who="5": self.on_click(who))  </span>

        <span class="hljs-comment">#使用封装，partial函数  </span>
        but = QPushButton(<span class="hljs-string">'6'</span>)  
        layout.addWidget(but)  
        but.clicked.connect(partial(self.on_click, <span class="hljs-string">'6'</span>))  

        layout.addWidget(self.lbl)  
        <span class="hljs-comment">#设置布局  </span>
        self.setLayout(layout)  

    <span class="hljs-comment">#传递额外参数     </span>
    <span class="hljs-function"><span class="hljs-keyword">def</span> <span class="hljs-title">cliked</span><span class="hljs-params">(self)</span>:</span>  
        bu = self.sender()  
        <span class="hljs-keyword">if</span> isinstance(bu, QPushButton):  
            self.lbl.setText(<span class="hljs-string">'%s is pressed'</span> % bu.text())  
        <span class="hljs-keyword">else</span>:  
            self.lbl.setText(<span class="hljs-string">'no effect'</span>)  
    <span class="hljs-function"><span class="hljs-keyword">def</span> <span class="hljs-title">on_click</span><span class="hljs-params">(self, n)</span>:</span>  
        self.lbl.setText(<span class="hljs-string">'%s is pressed'</span> % n)  

<span class="hljs-keyword">if</span> __name__ == <span class="hljs-string">'__main__'</span>:          
    app = QApplication(sys.argv)  
    bu =Bu1()  
    bu.show()  
    app.exec_()   </code></pre>

三：感谢[来源](http://blog.csdn.net/fengyu09/article/details/39498777) 

---

---

---


# 策略管理
策略类，引擎，报单管理&&仓位管理
## 引擎
引擎中将策略事件有序添加到事件引擎和主引擎中。 读取setting.json 文件对策略参数以及是否启用进行配置。设定日期。
使用策略实例字典保存策略名与实例关系——
并将此字典在推送字典中与tick数据ID对应（ID对多实例。）
再有orderID与策略对应字典，用以推送order和trade数据
计数本地停止单 、 持仓缓存字典


## 报单管理
### 成交推送处理
成交回调 - > 订单ID和策略对应字典 -> 计算策略持仓（根据策略方向，持仓增加交易笔数）-> 更新持仓缓存数据 

### 报单者类
单一合约订单缓存类——初始化buffer 存储字典_log策略日志存储


