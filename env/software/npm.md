# npm
## 树莓派
1. [官网下载](https://nodejs.org/en/download/) 树莓派4b 选择`ARMv8`之前的树莓派型号选择ARMv7
2. 配置PATH
3. 向`/usr/local/bin/`下建立`node`软链
```
ln -s ~/nodejs/bin/node /usr/local/bin/node
```
## Windows下wsl2 安装 npm && nodejs
摘抄自[微软说明文档](https://docs.microsoft.com/zh-cn/windows/dev-environment/javascript/nodejs-on-wsl)
1. 安装nvm (Node 版本管理器)
国内网可能有问题, 下载下保存直接`bash install.sh`就可安装.
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
```
2. `command -v nvm`验证是否安装成功,它会自行添加`.bashrc`需重启`bash`
3. `nvm ls`查看Node版本
4. `nvm install --lts`即可安装lts版, `nvm install node`安装最新版
5. 会安装这么多东西
```bash
->     v16.13.2
default -> lts/* (-> v16.13.2)
iojs -> N/A (default)
unstable -> N/A (default)
node -> stable (-> v16.13.2) (default)
stable -> 16.13 (-> v16.13.2) (default)
lts/* -> lts/gallium (-> v16.13.2)
lts/argon -> v4.9.1 (-> N/A)
lts/boron -> v6.17.1 (-> N/A)
lts/carbon -> v8.17.0 (-> N/A)
lts/dubnium -> v10.24.1 (-> N/A)
lts/erbium -> v12.22.9 (-> N/A)
lts/fermium -> v14.18.3 (-> N/A)
lts/gallium -> v16.13.2
```
6. 可以了 或者[官网下载](https://nodejs.org/en/download/)不过在wsl2里node好使唤,npm无效(只有0K)...
