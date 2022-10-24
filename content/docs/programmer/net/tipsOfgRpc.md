---
title: gRpc使用小记
date: 2021-05-24 10:30:41
categories: [tip, problem, gRpc]
tags: [win, rpc]
---
![gRpc](https://grpc.io/img/logos/grpc-logo.png "gRpc")
# gRpc HelloWorld

## helloWorld
[quickstart](https://grpc.io/docs/languages/go/quickstart/)
```bash
protoc --go_out=. --go_opt=paths=source_relative \
    --go-grpc_out=. --go-grpc_opt=paths=source_relative \
    helloworld/helloworld.proto
```
## MacOS下问题
- 原本`protobuf`中没有mac的gen-go和gen-go-grpc,所以需要额外运行安装.
- 除了使用brew用`go get`应该也是可以的,就是有路径问题,所以还是使用brew吧
```bash
brew install protobuf
brew install protoc-gen-go
brew install protoc-gen-go-grpc
```

