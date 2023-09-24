title: Mongodb使用记录
date: 2023-09-24 23:02:41
categories: [mongodb]
tags: [mongodb, docker]

# 安装
## Docker 安装 4.4.12版本

```Makefile
pull:
	docker pull mongo:4.4.13
run:
    docker run -itd --name mongo --restart=always \
        -v /mongodb/datadb:/data/db \
        -p 27017:27017 \
        --network websafe-network \
        --privileged=true mongo:4.4.12
```
进入容器`docker exec -it mongo bash`后:
```bash
mongo
use admin

# db.createUser({user: "admin", pwd: "admin", roles: [{role: "root", db: "admin"}]})
# db.createUser({user: "admin", pwd: "admin", roles: [{role: "userAdminAnyDatabase", db: "admin"}]})
# 如果能auth就不用createUser了
db.auth("admin", "admin")
```
网上传的将 `MONGO_INITDB_ROOT_PASSWORD` 和 `MONGO_INITDB_ROOT_USERNAME`传入环境变量的方式，在mongo4.4.12 和 4.4.13上都不好使。
