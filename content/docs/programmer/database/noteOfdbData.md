---
title: db数据库
date: 2018-05-15 09:51:09
categories: [note, db, learning]
tags: [mongo, mysql, learning]
---

# DB数据库 🖥 📊🖥
![db](https://webassets.mongodb.com/_com_assets/cms/kmxrodmee9int5s1v-HP_Highlight%202.svg)
## MongoDB笔记
学习网站：<http://www.runoob.com/mongodb/mongodb-tutorial.html>
    (其学习教程还挺可观，很多，不过还不清楚好不好)

### <font color=#ff5000>注意事项</font>
#### Mongo 数据库锁
mongo只提供库级粒度锁，所以一个写操作锁定时，其他读写操作都等待…   <font color=#d0a010>所以这个导致了Mongo多线程写操作反而没有一个线程写来的快？</font>

<font color=#d0a010>前台建立索引时</font>，`Mongo`需占用一个写锁（且不同上述、不会临时放弃）   <font color=#10d0a0>为避免此问题</font>需采用`background`方式
```ruby
    db.posts.ensureIndex({user_id: 1})  #此方式将引起全面战争

    db.posts.ensureIndex({user_id: 1}， {background: 1}) # 这个就比较和平
```
### 操作命令简单记录
#### 创建、插入 
    use DATABASE_NAME   #如果数据库不存在，则创建数据库，否则切换到指定数据库。
    show dbs        #查看所有数据库“name    size”
刚创建的数据库，如没有内容则不现实在其中
    
    db.runoob.insert({"name":"教程"})       #插入数据
#### 删除
    db.dropDatabase()       #删除当前数据库，如未选择则删除test
    db.collection.drop()        #删除集合
    db.site.drop()          #：如删除site集合

##### 删除重复数据
```mysql
    delete from alarm_calendar where id not in (SELECT maxid from (SELECT MAX(id) as maxid, 
    CONCAT(user_id,time,generic_name) as nameAndCode from alarm_calendar GROUP BY nameAndCode) t);
```
根据`user_id`, `time`, `generic_name`来打包重复，将重复数据删掉, 留下`max`，在自增里面即：最新数据

#### 插入文档
    db.COLLECTION_NAME.insert(document)
---
    db.col.insert({title: 'MongoDB 教程', 
        description: 'MongoDB 是一个 Nosql 数据库',
        by: '菜鸟教程',     
        url: 'http://www.runoob.com',       
        tags: ['mongodb', 'database', 'NoSQL'], 
        likes: 100
        })      #例如这样

db.col.find()       #查看已插入文档

也可以将document=括号里要插入内容，然后插入document变量，效果一样。
##### 3.2版本新加
    db.collection.insertOne()       #向指定集合中插入一条文档数据
    db.collection.insertMany()  #向指定集合中插入多条文档数据
---
    插入单条数据
    var document = db.collection.insertOne({"a": 3})
> document
{
        "acknowledged" : true,
        "insertedId" : ObjectId("571a218011a82a1d94c02333")
}

    插入多条数据    
    var res = db.collection.insertMany([{"b": 3}, {'c': 4}])
> res
{
        "acknowledged" : true,
        "insertedIds" : [
                ObjectId("571a22a911a82a1d94c02337"),
                ObjectId("571a22a911a82a1d94c02338")
        ]
}

### 更新、添加文档
    db.col.update({'title':'MongoDB 教程'},{$set:{'title':'MongoDB'}})      
    #更新标题
    
    db.collection.save(     
    #通过传入的文档来替换已有文档
    <document>,
    {
    writeConcern: <document>
    })
>参数说明：
document :  文档数据。
writeConcern :  可选，抛出异常的级别。

<font color=greeen>eg：</font>      实例中替换了 _id 为 56064f89ade2f21f36b03136 的文档数据：

    db.col.save({
    "_id" : ObjectId("56064f89ade2f21f36b03136"),
    "title" : "MongoDB",
    "description" : "MongoDB 是一个 Nosql 数据库",
    "by" : "Runoob",
    "url" : "http://www.runoob.com",
    "tags" : [
        "mongodb",
        "NoSQL"
    ],
    "likes" : 110
})

### 导入csv文件
    mongoimport --db Trader_1Min_Db --collection Au(T+D) --type csv --file 
    D:\\IFData\\md_Au(T+D)_20170101_20170531\\md_Au(T+D)_2017010301.csv 
    --headerline --upsert --ignoreBlanks
> 注意需要另开一个命令行，在其中运行。
>2017-10-25T08:43:40.917+0800 E QUERY    [thread1] SyntaxError: missing ; before statement @(shell):1:16 否则就是这个错误

    -d    指定把数据导入到哪一个数据库中
    -c    指定把数据导入到哪一个集合中
    --type    指定导入的数据类型   csv/tsv  逗号或者tab分割值
    --file       指定从哪一个文件中导入数据
    --headerline    仅适用于导入csv,tsv格式的数据，表示文件中的第一行作为数据头
    --upsert  以新增或者更新的方式来导入数据
    --f  导入字段名
    --ignoreBlanks 忽略空白符
### 导出
    mongoexport -d test -c students -o students.dat 
    connected to: 127.0.0.1 exported 9 records
    # 指明导出格式为csv
    mongoexport -d test -c students --csv -f classid,name,age -o students_csv.dat 
    connected to: 127.0.0.1 exported 9 records   
#### 添加
    db.collectionName.update({}, {$set:{'key' : value}}, false, true);

## 改
    .update
#### 更改字段名称
    db.CollectionName.update({}, {$rename : {"OldName" : "NewName"}}, false, true)
    # false为如不存在update记录，是否插入新的纪录  
    # ture位置为更新全部数据，如设定false 则为只更新第一条
    # 另外 没有输入名称时没有输全，也会显示查找，但不会执行更改
#### 统配 
    db.CollectionName.update(<query>, <update>,{upsert : <boolean>, multi : <boolean>, 
    writeConcern : <document>})
    # query : update 查找条件，类似sql update查询内where后面的
    # update : update的对象和一些更新的操作符（如$,$inc...）等，也可以理解为sql update查
    #>询内set后面的
    # upsert : 可选，这个参数的意思是，如果不存在update的记录，是否插入objNew,true为插
    #>入，默认是false，不插入。
    # multi : 可选，mongodb 默认是false,只更新找到的第一条记录，如果这个参数为true,就把
    #>按条件查出来多条记录全部更新。
    # writeConcern :可选，抛出异常的级别。
##### eg
    db.col.update({'title':'MongoDB'},{$set:{'title':'IamNewTitle'}})



#### 删除文档
remove()函数是用来移除集合中的数据。

    db.collection.remove(
    <query>,
    <justOne>
    )
##### 2.6版以后
    db.collection.remove(
    <query>,
    {
    justOne: <boolean>,
    writeConcern: <document>
    })
>参数说明：
query :（可选）删除的文档的条件。
justOne : （可选）如果设为 true 或 1，则只删除一个文档。
writeConcern :（可选）抛出异常的级别。

    db.col.remove({})   #删除所有 (就很恐怖)

#### 查询文档
|操作       |格式               |范例                           |RDBMS中的类似语句|
|   :----       |       :---:           |               :---:               | ---:                                              |
|等于       | {`<key>:<value>`}     | `db.col.find({"by":"教程"}).pretty()    `| `where by = '教程'`    |
|小于       | {`<key>:{$lt:<value>`}}   | `db.col.find({"likes":{$lt:50}}).pretty()`    | `where likes < 50   ` |
|小于或等于 | {`<key>:{$lte:<value>`}}  | `db.col.find({"likes":{$lte:50}}).pretty()`   | ...                       |
|大于       | {`<key>:{$gt:<value>`}}   | `db.col.find({"likes":{$gt:50}}).pretty()`    | ...               |
|大于或等于 | {`<key>:{$gte:<value>`}}  | `db.col.find({"likes":{$gte:50}}).pretty()`   | ...               |
|不等于     | {`<key>:{$ne:<value>`}}   | `db.col.find({"likes":{$ne:50}}).pretty()`    | `where likes != 50` |
##### And
find可以传入多个键(key),逗号隔开：

    db.col.find({key1:value1, key2:value2}).pretty()
    db.col.find({"by":"教程", "title":"MongoDB "}).pretty()
    #类似于
    WHERE by='教程' AND title='MongoDB '
##### Or
    db.test.find({$[{key1:value1},(key2:value2)]}).pretty()     #注意小中大括号😰
    db.col.find({"likes": {$gt:50}, $or: [{"by": "教程"},{"title": "MongoDB "}]})
##### And 与 Or
    db.col.find({"likes": {$gt:50}, $or: [{"by": "教程"},{"title": "MongoDB "}]})
    #类似于（其中pretty()是显示样式）
    where likes>50 AND (by = '教程' OR title = 'MongoDB ‘
#### 简写说明
|       |           |           |       |
|:----      |   :----:      |   :----:      |   ----:   |
|$gt        |--------       |greater than   |>      |
|$gte   |---------      |gt equal       |>=     |
|$lt        |--------       |less than      |<      |
|$lte       |---------      |lt equal       |<=     |
|$ne        |-----------    |not equal  |!=     |
|$eq    |--------       |equal          |=      |
##### Type
    db.col.find({"title" : {$type : 2}})    #获取“col”集合中title为String的数据
**对照表：**

|类型               |数字   |备注           |
|:---                   |   :---:   |           ---:    |
|Double             |1      |               |
|String             |2      |               |
|Object             |3      |               |
|Array              |4      |               |
|Binary data            |5      |               |
|Undefined          |6      |已废弃。           |   
|Object id              |7      |               |
|Boolean                |8      |               |
|Date               |9      |               |
|Null                   |10     |               |
|Regular Expression     |11     |               |
|JavaScript         |13     |               |
|Symbol             |14     |               |
|JavaScript (with scope)    |15     |               | 
|32-bit integer         |16     |               |
|Timestamp          |17     |               |
|64-bit integer         |18     |               |
|Min key                |255        |Query with -1.     |
|Max key                |127        |               |
##### Limit() Skip()方法
    db.col.find({},{"title":1,_id:0}).limit(2)
>参数说明：
    “title”后1为判断语句，表示是否只查询“title”内容0为否，显示这条的全部信息。_id的0亦为判断表示是否显示“_id”内容。limit为限制搜索信息条数。
    
    db.col.find({},{"title":1,_id:0}).limit(1).skip(1)
    skip(NUMBER)        #NUMBER为阶跃，即每隔几条数据来搜索

### 排序
    db.COLLECTION_NAME.find().sort({KEY:1})     #KEY后数字可为1OR-1，升序OR降序
    db.col.find({},{"title":1,_id:0}).sort({"likes":-1}     #按“likes”降序排序

---

---

### MongoDB 索引        （<font color=crimson>建立索引干嘛……</font>）
#### ensureIndex() 方法
    db.COLLECTION_NAME.ensureIndex({KEY:1})
    # Key 值为要创建的索引字段，1为指定按升序创建索引，降序-1

### 聚合
#### aggregate()方法
    db.COLLECTION_NAME.aggregate(AGGREGATE_OPERATION)
    db.mycol.aggregate([{$group : {_id : "$by_user", num_tutorial : {$sum : 1}}}])
    #类似于
    select by_user, count(*) from mycol group by by_user
>输出结果：
{ "_id" : "Neo4j", "num_tutorial" : 1 }
{ "_id" : "runoob.com", "num_tutorial" : 2 }
{ "_id" : null, "num_tutorial" : 1 }

>参数说明：“$by_user” 即为分类依据，并打印出来（如上）。
num_tutorial 仅为显示提示，可以更改为任意提示甚至汉字。
$sum : 1 其中1为每次计数值，即重复一次加几。1+1+1+1…… ：重复一次加1；0.1+0.1+0.1……重复一次加0.1。这个意思

##### 计算符：
|表达式     |描述   |   实例        |
|:---           |   :---:   |       :---:   |
|$sum   |计算总和。 |`db.mycol.aggregate([{$group : {_id : "$by_user", num_tutorial : {$sum : "$likes"}}}])`|
|$avg   |计算平均值 |`db.mycol.aggregate([{$group : {_id : "$by_user", num_tutorial : {$avg : "$likes"}}}])`|
|$min   |获取集合中所有文档对应值得最小值。 |`db.mycol.aggregate([{$group : {_id : "$by_user", num_tutorial : {$min : "$likes"}}}])`|
|$max   |获取集合中所有文档对应值得最大值。 |`db.mycol.aggregate([{$group : {_id : "$by_user", num_tutorial : {$max : "$likes"}}}])`|
|$push  |在结果文档中插入值到一个数组中。   |`db.mycol.aggregate([{$group : {_id : "$by_user", url : {$push: "$url"}}}])`|
|$addToSet  |在结果文档中插入值到一个数组中，但不创建副本。 |`db.mycol.aggregate([{$group : {_id : "$by_user", url : {$addToSet : "$url"}}}])`|
|$first |根据资源文档的排序获取第一个文档数据。 |`db.mycol.aggregate([{$group : {_id : "$by_user", first_url : {$first : "$url"}}}])`|
|$last  |根据资源文档的排序获取最后一个文档数据 |`db.mycol.aggregate([{$group : {_id : "$by_user", last_url : {$last : "$url"}}}])`|

### 条件操作符
    $gt     大于
    $lt     小于
    $gte        大于等于
    $lte        小于等于
#### eg：
    db.col.find({likes : {$gte : 100}})
    # 查询“col”集合中"likes"大于100的数据
    # 比较与 `SQL       Select * from col where likes >=100;`
#### 取前n条数据
    .find().limit(n)

### 执行顺序
    skip(), limilt(), sort()三个放在一起执行的时候，执行的顺序是先 sort(), 
    然后是 skip()，最后是显示的 limit()。

## 数据导出
    mongoexport -d *** -c *** -o ***
    # -d 后为 dbName
       -c 后为 collectionName
       -o 后为 outputFileName 导出文件名

名字都不用加引号，直接上的~，  然后导出格式都是json 那样，不管后缀是什么用文本打开都是一个样子——骗鬼👻
## 数据导入
     mongoimport -h 127.0.0.1 -p 27017 -d Trader_1Min_Db -c ag1806 --file 
    /home/ian/Downloads/ag1806.json
### Linux 下使用Robo3T错误
错误最后字段为：已放弃 (核心已转储)

    mkdir ~/robo-backup
    mv robo3t-1.1.1-linux-x86_64-*/lib/libstdc++* 
~/robo-backup/robo3t-1.1.1-linux-x86_64-*/bin/robo3t
    移动备份之后即可运行
# For Python
## PyMongo
    from pymongo import MongoClient
    client = MongoClient("localhost", 27017)
    client.server_info()    
    # 查看信息，检测是否成功连接
    db = client["someData"]
    collection = db.zn1801_30Min
    # 两种命名方式，一种是直接.     一种是使用“”
乖乖的用<font color = red>双引号</font>，因为，在这里的单双引号是区分的… 我现在也懒得去管它是字符字符串的什么鬼。┏┛墓┗┓...(((m -__-)m
#### insert
    collection.insert( {"name":"text" } )
#### find
    d = {u'Volume':{'$gte':50353,'$lte':50355}}
    a = collection.find(d)
最小与最大，另外，find出来的东西是数据库指针，需要用`for...in...`来循环取出内容来

## 查询库名
    from pymongo import MongoClient
    client = MongoClient('localhost', 27017)
    client.database_names()
>[u'Trader_1Min_Db', u'Trader_30Min_Db', u'Trader_Tick_Db', u'VnTrader_Log_Db', u'VnTrader_Position_Db', u'admin', u'local', u'someData', u'test']

### 查询集合名
    collectionNames = client[dbName].collection_names()
    print collectionNames





# 使用
其读写速度还是可以的…  二十万条数据查询的话不到一秒，然而…   频繁多量的读取，再加上不断地往其中写入就出问题了…… 卡的极慢…简直恐怖（数个小时的延迟 怕不怕）。（当然以上情况是完全没有做任何优化的情况（直接`insert` 、`find`），不知道优化之后会怎样）  另外不知道不增加条数，去增加内容会怎样…… emm  果然还是缓存比较好用…在高速多量<font color = red>多频次</font>的情况下还是用内存里面不去手动做任何保存比较好。 等积攒够量之后再去保存，就好比文件压缩不去一个个小文件传输一个道理。


---

---
---

---

## MySQL

### MySQL 8.0
因为在更新8.0 之后更改了用户密码加密形式所以在使用客户端连接的时候会出现错误，所以需要

    ALTER USER 'root'@'localhost' IDENTIFIED BY 'password' 
        PASSWORD EXPIRE NEVER; #修改加密规则  
    ALTER USER 'root'@'localhost' IDENTIFIED WITH 
        mysql_native_password BY 'password';  #更新用户的密码  
    FLUSH PRIVILEGES; #刷新权限
经此步骤，就可以将密码加密形式改为图形化客户端支持的加密形式，也或者更待客户端跟着服务端同步更新。

另外，配置之初，windows 中配置步骤如下：
1.  添加系统环境变量path    为MySQL/bin
2. 初始化 `mysqld --initialize --user=mysql --console`
3. 根据初始化随机生成密码登陆
4. 修改密码   emm 这里说的是在外部，当然也可以在修改加密形式的时候一并修改 😄 `mysqladmin -u root -p password`
5. 添加系统服务 `mysqld -install`
6. 启动服务 `net start mysql`

另外在图像化里面注意密码格式呦，还有使用navicat的话需要最新版本，否则无法设置加密格式，还得用命令行去修改……果然还是命令行永远最好用

### update
`MySQL`的`update`在被更新数值和更新传入数值相同时，执行速度相当的快，据说是mysql并<font color=#f05710>不会执行更新动作</font>但是它<font color=#f05710>晓得</font>更新动作的发生


## MySQL 中文乱码
需要在连接时就指定✱charset✲    而不该一味纠结于在程序在存储时的数据准备
此处使用的是 

    charset='gb2312'


另外，干脆就在数据库中设置存为 blob 格式

## 连接远程 win 数据库
```md
开启某端口的示例：

添加防火墙例外端口

## 导出表记录
[^_^]
    2021-04-22 看了上面,深表惭愧...
```bash
mysql -uuser -ppasswd -hhost -e "use db_name; select * from table_name where chat_id in (...);" >> hello2.csv
```
在`bash`中直接执行`sql`语句，重定向保存
### 好处
可以规避 `into outfile` 的权限问题，导出的东西用csv也是可以看的，分隔符得以保留，csv可以正常阅览
### 注意点
只不过有`,`时分隔符可能有些问题，全文替换了就好

##### 入站规则设置
第一步 选择 入站规则 然后 新建规则，选择 端口，然后下一步 
第二步 选择TCP 选择特定端口 然后输入端口，如有多个端口需要用逗号隔开了 例如: 3306
第三步 选择允许连接
第四步 选择配置文件 
第五步 输入规则名称 mysqlport


##### 出站规则设置
第一步 选择出站规则 然后 新建规则，选择 端口，然后下一步 
第二步 选择TCP 选择特定端口 然后输入端口，如有多个端口需要用逗号隔开了 例如: 3306
第三步 选择允许连接
第四步 选择配置文件 
第五步 输入规则名称 mysqlport（或者无特殊要求下直接关闭防火墙）
```

---

---

---

# 数据迁移
因为已有从数据库中读取数据进行返回的函数，所以没有必要再去写读取数据库的步骤（也没法写，因为数据库设计混乱，分不清哪儿是哪儿只有通过其对外函数才能取对相应数据）
但对外其是将一段时间内数据全部读取并且打包为`json`返回，所以一次性的话将是极大的一个文件，所以解决方法有：

- 阅读其中源码，返回相应数据库指针，以此取出一个迁移一个
- 编写分段读取函数，保证每次取出的数据不多，一段一段的迁移

反正我是采用`一段一段`了，毕竟源码太…   另外，一段一段的话打好日志，出现问题后可以分段纠正，也能间歇运行，另外下载好再迁也保证了数据emm，考虑如上

## 简单总结
- 数据迁移程序
- 数据检验补差程序
- 断点运行机制


```md
# 初始化
1. 读取配置文件（其中保存
* 数据迁移顺序——列表（内元素为字典key为* value为相应数据库、表名，
    时间起止，一次插入的时间跨度） ）

2. 根据移植顺序读取目标数据库中相应数据的最新数据日期（
* 若为空开始则开始插入）
* 删除此日期的所有数据，
* 根据一次插入的时间跨度以及终点生成时间区间
* 根据时间区间去移植数据

3. 当此类型数据移植完毕之后删除配置文件中列表的相应元素
# 执行动作
是

## 日志
将每一步的重要信息都打印~
```
