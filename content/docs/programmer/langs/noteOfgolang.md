---
title: Golang笔记
date: 2018-05-15 10:18:26
categories: [note, golang, learning]
tags: [golang, learning]
---
# Golang笔记
![golang](https://wallpapercave.com/wp/wp7041189.jpg "tmp")

先贴一个客观的教程文档网站<http://www.runoob.com/go/go-slice.html>

## 并发 Channel
使用关键字`go`开启`goroutine`
轻量级线程
```go
go fun_name(paras_list)

# eg: go f(x, y, z)
```
[代码](https://www.runoob.com/go/go-concurrent.html)
```go
package main

import (
        "fmt"
        "time"
)

func say(s string) {
        for i := 0; i < 5; i++ {
                time.Sleep(100 * time.Millisecond)
                fmt.Println(s)
        }
}

func main() {
        go say("world")
        say("hello")
}
```
### Channel
用于传递数据的数据结构
可用于两个`goroutine`之间传递指定类型值，同步和通讯
`<-` 指定通道方向(发送or接受)，未指定则双向通道

#### 声明通道
使用`chan`关键字, 在使用之前，需先创建.
```go
ch := make(chan int)
```
示例
```go
package main
import "fmt"

func sum(s []int, c chan int) {
        sum := 0
        for _, v := range s {
                sum += v
        }
        c <- sum // 把 sum 发送到通道 c
}

func main() {
        s := []int{7, 2, 8, -9, 4, 0}

        c := make(chan int)
        go sum(s[:len(s)/2], c)
        go sum(s[len(s)/2:], c)
        x, y := <-c, <-c // 从通道 c 中接收

        fmt.Println(x, y, x+y)
}
```
#### Cache
在创建通道时可创建缓冲区，做压入存储
```go
ch := make(chan int, 100)   // cache size
```
```go
package main
import "fmt"

func main() {
    // 这里我们定义了一个可以存储整数类型的带缓冲通道
    // 缓冲区大小为2
    ch := make(chan int, 2)

    // 因为 ch 是带缓冲的通道，我们可以同时发送两个数据
    // 而不用立刻需要去同步读取数据
    ch <- 1
    ch <- 2

    // 获取这两个数据
    fmt.Println(<-ch)
    fmt.Println(<-ch)
}
```


## Vim 高亮
emmmm，偶尔会有不支持Go高亮的情况
所以，步骤如下：
```shell
cd ~
mkdir .vim
cd .vim
mkdir autoload  plugged
cd plugged
git clone https://github.com/fatih/vim-go vim-go
cd autoload
wget https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```
配置 `.vimrc`
```
cat ~/.vimrc
```
set shiftwidth=4 softtabstop=4 expandtab
call plug#begin()
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
call plug#end()
let g:go_version_warning = 0
over~!

### 函数定义
```go
func function_name([参数列表])[返回类型]{
    balabala
}
```
如：
```go
func Divide(varDividee int, varDivider int) (result int, errorMsg string) {
    if varDivider == 0 {
        dData := DivideError{
            dividee: varDividee,
            divider: varDivider,
    }
    errorMsg = dData.Error()
    return
    } else {
        return varDividee / varDivider, ""
    }
}
```
### 接口
```go
package main
import (
    "fmt"
)
# 或者 直接 import "fmt"
type Phone interface {
    call()
    }
type NokiaPhone struct {
}
func (nokiaPhone NokiaPhone) call() {
    fmt.Println("I am Nokia, I can call you!")
}
type IPhone struct {
}
func (iPhone IPhone) call() {
    fmt.Println("I am iPhone, I can call you!")
}
func main() {
    var phone Phone
    phone = new(NokiaPhone)
    phone.call()
    phone = new(IPhone)
    phone.call()
}
```
### 错误
```go
package main
import (
    "fmt"
)
// 定义一个 DivideError 结构
type DivideError struct {
    dividee int
    divider int
}
// 实现     `error` 接口
func (de *DivideError) Error() string {
// 以上函数中，取结构体地址是（等同于面向对象实例化对象吧，然后下方可以
//  de.使用.的方式去调取结构体中定义的某变量）
//错误Error()是调用接口中的函数，制定返回类型为string
    strFormat := `
    Cannot proceed, the divider is zero.
    dividee: %d
    divider: 0
`
    return fmt.Sprintf(strFormat, de.dividee)
}
// 定义 `int` 类型除法运算的函数
func Divide(varDividee int, varDivider int) (result int, errorMsg string) {
    if varDivider == 0 {
        dData := DivideError{
            dividee: varDividee,
            divider: varDivider,
        }
        errorMsg = dData.Error()
        return
    } else {
        return varDividee / varDivider, ""
    }
}
func main() {

    // 正常情况
    if result, errorMsg := Divide(100, 10); errorMsg == "" {
        fmt.Println("100/10 = ", result)
    }
    // 当被除数为零的时候会返回错误信息
    if _, errorMsg := Divide(100, 0); errorMsg != "" {
            fmt.Println("errorMsg is: ", errorMsg)  
    }
}
```

## 以上总结
函数定义真是…   也或许刚开始接触太多。也不知道这么设计的目的
其中 功能重写见d.Data.Error。先是将d.Data定义为结构体，然后再去调用结构体下的Error，分明结构体里并没有定义，所以下面的那个函数定然是将Error,与DicideError连接的函数。 

所以Go并没有类与对象一说吧… 

生动点来说那个函数（`func (de *DivideError) Error() string {...}`）的定义就好像是在强行给这个地址的<font color=pink>结构体</font>中<font color=yellow>塞进去一个执行函数</font>。 一个言简意骇的<font color=green>对象</font>实现方法

## go的循环
- golang 只有for  while==for
- golang 中没有小括号包裹, 只需要用{}分隔作用域就可以

for 可以有
1. for A;B;C {}
2. for ;B; {}
3. for {}

## go的switch
- 每个case自动break
- fallthrough 显式声明可以继续执行下一个case
- case 无需常量
- `switch {case}` 可做 if-else 用

## go的指针
go的指针 没有`指针运算`.
