---
title: Golang进阶笔记
date: 2021-05-19 19:00:00
modified: 2021-10-29 11:03:59
categories: [note, golang, expansion]
tags: [golang, expansion]
---
# Golang进阶笔记
![golang](https://wallpapercave.com/wp/wp7041189.jpg "power")

## 路径问题
### test_test.go 
```go
package main

import "testing"

func TestHelloWorld(t *testing.T) {
	// t.Fatal("not implemented")
	path := getCurrentPath()
	t.Log("getCurrentPath: ", path)
}
```
### test.go
```go
package main

import (
	"fmt"
	"log"
	"os"
	"path"
	"path/filepath"
	"runtime"
	"strings"
)

func main() {
	fmt.Println("getTmpDir（当前系统临时目录） = ", getTmpDir())
	fmt.Println("getCurrentAbPathByExecutable（仅支持go build） = ", getCurrentAbPathByExecutable())
	fmt.Println("getCurrentAbPathByCaller（仅支持go run） = ", getCurrentAbPathByCaller())
	fmt.Println("getCurrentAbPath（最终方案-全兼容） = ", getCurrentAbPath())
	fmt.Println("getCurrentPath（runtime.Caller1） = ", getCurrentPath())
}

// 最终方案-全兼容
func getCurrentAbPath() string {
	dir := getCurrentAbPathByExecutable()
	if strings.Contains(dir, getTmpDir()) {
		return getCurrentAbPathByCaller()
	}
	return dir
}

func getCurrentPath() string {
	_, filename, _, _ := runtime.Caller(1)

	return path.Dir(filename)
}

// 获取系统临时目录，兼容go run
func getTmpDir() string {
	dir := os.Getenv("TEMP")
	if dir == "" {
		dir = os.Getenv("TMP")
	}
	res, _ := filepath.EvalSymlinks(dir)
	return res
}

// 获取当前执行文件绝对路径
func getCurrentAbPathByExecutable() string {
	exePath, err := os.Executable()
	if err != nil {
		log.Fatal(err)
	}
	res, _ := filepath.EvalSymlinks(filepath.Dir(exePath))
	return res
}

// 获取当前执行文件绝对路径（go run）
func getCurrentAbPathByCaller() string {
	var abPath string
	_, filename, _, ok := runtime.Caller(0)
	if ok {
		abPath = path.Dir(filename)
	}
	return abPath
}
```
### 输出
```bash
ian@ianDebian:~$ ./test
getTmpDir（当前系统临时目录） =  .
getCurrentAbPathByExecutable（仅支持go build） =  /home/ian
getCurrentAbPathByCaller（仅支持go run） =  /home/ian
getCurrentAbPath（最终方案-全兼容） =  /home/ian
getCurrentPath（runtime.Caller1） =  /home/ian
ian@ianDebian:~$
ian@ianDebian:~$ go run test.go
getTmpDir（当前系统临时目录） =  .
getCurrentAbPathByExecutable（仅支持go build） =  /tmp/go-build3048077768/b001/exe
getCurrentAbPathByCaller（仅支持go run） =  /home/ian
getCurrentAbPath（最终方案-全兼容） =  /tmp/go-build3048077768/b001/exe
getCurrentPath（runtime.Caller1） =  /home/ian
ian@ianDebian:~$
ian@ianDebian:~$ go test test_test.go test.go -v
=== RUN   TestHelloWorld
    test_test.go:8: getCurrentPath:  /home/ian
--- PASS: TestHelloWorld (0.00s)
PASS
ok  	command-line-arguments	0.002s
```
## Docker问题
### Docker Mysql编码
```docker-compose
version: "2.2"
services:
  redis:
    image: "redis"
    # ports:
    #  - 6379:6379
    command: redis-server --appendonly yes #一个容器启动时要运行的命令
    restart: always # 自动重启
  myserver:
    image: mainName/myserver
    restart: always # 自动重启
  mainServer:
    image: mainName/mainServer
    #    container_name: mainServerv1.0.0
    depends_on:
      - redis
    ports:
      - 9001:9001
    restart: always
    volumes:
      - "./logs:/src/build/logs"
    links:
      - redis
      - myserver
```
**mysql 编码问题|单条**: `docker run --name predix_mysql -e MYSQL_ROOT_PASSWORD=predix123predix -p 33061:3306  -e LANG=C.UTF-8 -d mysql:5.7 --character-set-server=utf8mb4 --collation-server=utf8mb4_general_ci`

### 时间修改
```Dockerfile
FROM alpine:3.14
RUN apk add -U tzdata && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime &&  echo "Asia/Shanghai" > /etc/timezone

ENV TZ=Asia/Shanghai \
    GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64 \
    PROGRAM_ENV=pro

WORKDIR /src/build

# 复制构建应用程序所需的代码
COPY ./build .

EXPOSE 8088

CMD ["./main"]
```
## Golang 私有仓库
`xxx`替换为具体地址
```bash
export GOPRIVATE=github.com/xxx/xxx
```
修改`~/.gitconfig`让`go get`始终通过`ssh`而非`http`
```.gitconfig
[url "git@github.com:"]
        insteadOf = https://github.com/
[url "git@gitlab.com:"]
        insteadOf = https://gitlab.com/
```

### `-`和`_`不同的分隔符引发的包导入错误
适用于`Github`仓库名为`xxxxx-xxxxx`但包名为`xxxxx_xxxxx`, 因为go mod 不支持`-`分隔.
```go
module example.com

go 1.16

replace github.com/xxx-xx/xxxxx_xxxxx => github.com/xxx-xx/xxxxx-xxxxx v0.0.1 // indirect
require github.com/xxx-xx/xxxxx_xxxxx v0.0.1
```

## 非硬性结束服务
### http.Server.Shutdown
`http.Server`结构体有一个终止服务的方法`Shutdown`
1. 首先关闭所有开启的监听器
2. 关闭所有闲置连接
3. 等待活跃的连接均闲置了才终止服务
#### 长链接
对诸如WebSocket等的长连接，Shutdown不会尝试关闭也不会等待这些连接。若需要，需调用者分开额外处理（诸如通知诸长连接或等待它们关闭，使用RegisterOnShutdown注册终止通知函数）

### signal.Notify
可指定信号类型/`all incoming signals will be relayed to c`

### 综上
#### Demo1
```go
    srv := http.Server{
        Addr:    *addr,
        Handler: handler,
    }

    // make sure idle connections returned
    processed := make(chan struct{})
    go func() {
        c := make(chan os.Signal, 1)
        signal.Notify(c, os.Interrupt)
        <-c

        ctx, cancel := context.WithTimeout(context.Background(), 3*time.Second)
        defer cancel()
        if err := srv.Shutdown(ctx); nil != err {
            log.Fatalf("server shutdown failed, err: %v\n", err)
        }
        log.Println("server gracefully shutdown")

        close(processed)
    }()

    // serve
    err := srv.ListenAndServe()
    if http.ErrServerClosed != err {
        log.Fatalf("server not gracefully shutdown, err :%v\n", err)
    }

    // waiting for goroutine above processed
    <-processed
}
```

#### Demo2
```go
func main() {
	c := make(chan os.Signal)
	// 监听信号
	signal.Notify(c, syscall.SIGHUP, syscall.SIGINT, syscall.SIGTERM, syscall.SIGQUIT, syscall.SIGUSR1, syscall.SIGUSR2)

	go func() {
		for s := range c {
			switch s {
			case syscall.SIGHUP, syscall.SIGINT, syscall.SIGTERM:
				fmt.Println("退出:", s)
				ExitFunc()
			case syscall.SIGUSR1:
				fmt.Println("usr1", s)
			case syscall.SIGUSR2:
				fmt.Println("usr2", s)
			default:
				fmt.Println("其他信号:", s)
			}
		}
	}()
	fmt.Println("启动了程序")
	sum := 0
	for {
		sum++
		fmt.Println("休眠了:", sum, "秒")
		time.Sleep(1 * time.Second)
	}
}

func ExitFunc() {
	fmt.Println("开始退出...")
	fmt.Println("执行清理...")
	fmt.Println("结束退出...")
	os.Exit(0)
}
```

#### Demo3
```go
package main

import (
    "log"
    "io"
    "time"
    "net/http"
)

func startHttpServer() *http.Server {
    srv := &http.Server{Addr: ":8080"}

    http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
        io.WriteString(w, "hello world\n")
    })

    go func() {
        if err := srv.ListenAndServe(); err != nil {
            // cannot panic, because this probably is an intentional close
            log.Printf("Httpserver: ListenAndServe() error: %s", err)
        }
    }()

    // returning reference so caller can call Shutdown()
    return srv
}

func main() {
    log.Printf("main: starting HTTP server")

    srv := startHttpServer()

    log.Printf("main: serving for 10 seconds")

    time.Sleep(10 * time.Second)

    log.Printf("main: stopping HTTP server")

    // now close the server gracefully ("shutdown")
    // timeout could be given instead of nil as a https://golang.org/pkg/context/
    if err := srv.Shutdown(nil); err != nil {
        panic(err) // failure/timeout shutting down the server gracefully
    }

    log.Printf("main: done. exiting")
}
```
