---
title: 愉快的Java(happy to learn the fuck java)
date: 2018-5-24 09:52:00
modified: 2018-6-7 19:52:00
categories: [note, java, learning]
tags: java, springboot, mybatis, maven, learning
slug: notesJava
---
author: Ian

# happy to the fuck java 😅
## <微人事> 笔记 ->    ψ(._. )>

先贴[官方文档](https://github.com/lenve/vhr/wiki/1.权限数据库设计) 哦 还有[官方项目地址](https://github.com/lenve/vhr)

#### 爪哇方法定义:
```java
修饰符  返回值类型  方法名(参数类型  参数名){
    方法体;
	return 返回值;
}

# 示个例
public boolean NiHou(int num){
	int a = num;
	return turn;
}

// `boolean` 处 可为
public Collection<? extends GrantedAuthority> getAuthorities(){
	List<GrantedAuthority> authorities = new ArrayList<>();
	return authorities;
}
// 表泛型中可以是的`GrantedAuthority`所有子类
```
#### 爪哇抽象方法(即Python父类中直接`pass`的函数…)
<font color=#ff0000>`abstract`</font>
1. 包含抽象方法必须得是抽象类
2. 任何子类必须重写父类抽象方法，或者声明自身为抽象类
```java 
public abstract class Employee
{
   private String name;
   private int number;
   
   public abstract double computePay();
   
   //其余
}

```

#### 爪哇接口
<font color=#ff0000>`interface`</font>, <font color=#0000ff>`implements`</font>
```java 
[可见度] interface 接口名称 [extends 其他的类名] {
    // 声明变量
    // 抽象方法
}

# 示个例
/* 文件名 : NameOfInterface.java */
public interface NameOfInterface
{
   //任何类型 final, static 字段
   //抽象方法
}
Interface关键字用来声明一个接口。
```


#### 爪哇抽象类
<font color=#ff0000>`abstract class`</font><font color=#0000ff>`extends`</font>
1. 不能直接实例化
2. 只能被继承后实例
```java
public abstract class Employee
{
   private String name;
   private String address;
   private int number;
   public Employee(String name, String address, int number)
   {
      System.out.println("Constructing an Employee");
      this.name = name;
      this.address = address;
      this.number = number;
   }
   //…… 等方法
   public int getNumber()
   {
     return number;
   }
}


/* 文件名 : Salary.java */    
// 用于继承上述东西
public class Salary extends Employee
{
   private double salary; //Annual salary
   public Salary(String name, String address, int number, double
      salary)
   {
       super(name, address, number);
       setSalary(salary);
   }
   public void mailCheck()
   {
       System.out.println("Within mailCheck of Salary class ");
       System.out.println("Mailing check to " + getName()
       + " with salary " + salary);
   }
   public double getSalary()
   {
       return salary;
   }
   public void setSalary(double newSalary)
   {
       if(newSalary >= 0.0)
       {
          salary = newSalary;
       }
   }
   public double computePay()
   {
      System.out.println("Computing salary pay for " + getName());
      return salary/52;
   }
}


/* 文件名 : AbstractDemo.java */
// 用于实现继承类   
public class AbstractDemo
{
   public static void main(String [] args)
   {
      Salary s = new Salary("Mohd Mohtashim", "Ambehta, UP", 3, 3600.00);
      Employee e = new Salary("John Adams", "Boston, MA", 2, 2400.00);
 
      System.out.println("Call mailCheck using Salary reference --");
      s.mailCheck();
 
      System.out.println("\n Call mailCheck using Employee reference--");
      e.mailCheck();
    }
}

```
#### 爪哇类
<font color=#ff0000>`class`</font>, <font color=#0000ff>`extends`</font>
```java 

```




---

---
# Maven 项目标准目录结构
str
|	main
	|	bin	脚本库
    |	java Java源代码文件
    |	resources 资源库，会自动复制到classes目录中
    |	filters 资源过滤文件
    |	assembly 组建的描述配置（如何打包）
    |	config 配置文件
    |	webapp web应用的目录。WEB-INF、css、js等
|	test
	|	java 单元测试Java源代码文件
    |	resorces 测试需要用到的资源库
    |	filters 测试资源过滤库
    |	site Site（一些文档）
|	target
	LICENSE.txt Project's license
    README.txt Project's readme
    
工程根目录下就只有src和target两个目录
target是有存放项目构建后的文件和目录，jar包、war包、编译的class文件等。
target里的所有内容都是maven构建的时候生成的

顶级目录工程的描述文件`pom.xml`


摘自: <https://blog.csdn.net/lengyue_wy/article/details/6718637>
    

## src 
### java
***Bean***: 扮演应用程序素材的角色（其中放置了各种自定义类 如：Hr、Role、Employee、menu等数据类型）（作为`service`的<font color=#00cfaf>模型库</font>）
***common***: 常用方法 （如字符串转换、邮件、几个查询） 
***config***: 看不懂的设置
***controller***: 动作执行，即受到什么请求执行什么动作。 但是我打了断点鲜有进来的。所以具体实现过程还是不清楚。 另外其url地址与网页真正输入地址有全拼简写的区别，哪里有指定也没找到还。（并且寥寥草草一个就处理完了，所以肯定是简写了💩）
***exception***: 异常处理
***mapper***: 虽不觉然明厉的东西集合_20180525_其中定义了诸多做实事的接口，在`.java`文件中画饼，在`.xml`中实现，另外昨天在查资料时，还了解到有人要将`.java`与`.xml`分开来存放，解决方法是将`.xml`放在`resources`文件夹中，仿照在`java`文件夹中的路径，依瓢葫芦画😄的建立相同路径，如此一来在coding阶段看起来是分开的，但在building阶段编译器就是看作在同一目录下了——由此引发了虽然拆开了他们的人，却没有拆散他们的心的哲学论题😰(作为`service`的<font color=#bf00cf>方法库</font>)
***service***: 动作逻辑服务，和controller中类似，不过详细不少（作为）

---

### resources
***ftl***: emm……
***static***: 静态资源
***js***: emm…
***application.properties***: 各项配置
***mybatis-config.xml***: MySQL数据库配置


### Mybatis
##### 头
```java
<?xml version="1.0" encoding="utf-8"?>  
<!DOCTYPE configuration PUBLIC "-//mybatis.org//DTD Config 3.0//EN"  
"http://mybatis.org/dtd/mybatis-3-config.dtd">  
<configuration>  
  
</configuration>
```
##### configuration中的配置信息
详解： <https://blog.csdn.net/yqynsmile/article/details/52807815>
```java
// 别名，假名，代称
<typeAliases>  
<typeAlias alias="Student" type="com.mybatis3.domain.Student" />  
</typeAliases>  

// 声明环境变量
<environments default="development">  
<environment id="development">  

/* 声明数据源，数据源的类型有NOPOOLED ，POOLED ，还有JIDN.
 在数据量少的话用ONPOOLED，测试和开发过程一般用POOLED，实际运行使用JIDN */
<dataSource type="POOLED">  

// <mappers>：声明我们定义的一个个Mapper类，或者说是关联
<mapper resource="com/mybatis3/mappers/StudentMapper.xml" /> 

// <property>：jdbc连接的一些属性
<property name="driver" value="com.mysql.jdbc.Driver" />  
<property name="url" value="jdbc:mysql://localhost:3306/test" />  
<property name="username" value="root" />  
<property name="password" value="admin" />  
/* 这些东西貌似也可以写在其他地方：application中
 <property name="url">  
         <value>jdbc:mysql://localhost:3306/springmybaitis?useUnicode=true&amp;characterEncoding=UTF-8</value>  
        <!--springmybaitis是我的数据库  -->
     </property>  或 spring.datasource.url=jdbc:mysql://127.0.0.1:3306/vhr?useUnicode=true&characterEncoding=UTF-8    两种写法而已 */

// <mapper>：声明Mapper的路径


// 默认setting配置
<setting name="cacheEnabled" value="true" />//是否使用缓存  
<setting name="lazyLoadingEnabled" value="true" />//是否是懒记载  
<setting name="multipleResultSetsEnabled" value="true" />  
<setting name="useColumnLabel" value="true" />  
<setting name="useGeneratedKeys" value="false" />  
<setting name="autoMappingBehavior" value="PARTIAL" />  
<setting name="defaultExecutorType" value="SIMPLE" />  
<setting name="defaultStatementTimeout" value="25000" />  
<setting name="safeRowBoundsEnabled" value="false" />  
<setting name="mapUnderscoreToCamelCase" value="false" />  
<setting name="localCacheScope" value="SESSION" />  
<setting name="jdbcTypeForNull" value="OTHER" />  
<setting name="lazyLoadTriggerMethods" value="equals,clone,hashCode ,toString" />  
```
还有 `<Settings>`:声明一些全局变量、`<typeHandlers>`: 自定义我们的传入参数类型处理器、`<properties>`: 声明属性文件的key和value，但使用.properties文件将会被覆盖。

***注***: 在要使用指定日志工具时，需要在`<Settings>`里指定`<setting name="logImpl" value="LOG4J"/>`







#### equals 与 ==
`equals` 对比两者是否类型一致，内容一致
`==`	则会由于 不同对象而`False`
```java 
String str1=new String("hello");
String str2=new String("hello");

str1==str2   输出：false,因为不同对象
int1.equals(int2)   输出：TRUE

// 无论 整形 or 字符串等
```

## 爪洼调用Python 
爪哇语有个通用调用方式，就是通过`Runtime`，也就是通过命令行执行，然后通过`BufferedReader`捕获命令行（内存）中的信息。但数据传输只能通过字符串，另外，python回传数据也只能通过`print`来回传，所以……基本没啥用.
