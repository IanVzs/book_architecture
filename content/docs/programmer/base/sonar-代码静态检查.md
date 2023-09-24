[平台地址](https://127.0.0.1/) 需要自建

在平台新建项目，新建token后可以自动生成扫描命令(拉代码, cd进去后在项目代码`/`路径下执行)：
```bash
sonar-scanner \
  -Dsonar.projectKey=scancenter \
  -Dsonar.sources=. \
  -Dsonar.host.url=https://sonar-xa.inone.nsfocus.com \
  -Dsonar.login=3e569f7abcfd8a64067d790f038c57a6a6b73207
```
如果使用的是他人的token，需要给授权。
