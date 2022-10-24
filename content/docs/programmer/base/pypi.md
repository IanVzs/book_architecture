---
title: PyPi
date: 2022-03-31 15:15:14
category: [note, pip, pypi]
tags:
---

![pypi](https://pypi.org/static/images/logo-large.6bdbb439.svg "pip")

## 示例项目
[py-muti-scrcpy](https://github.com/IanVzs/py-muti-scrcpy/)

## 配置文件
[pyproject](https://github.com/IanVzs/py-muti-scrcpy/blob/main/pyproject.toml)

## 工具介绍
[poetry](https://github.com/python-poetry/poetry)

### 增加安装包
直接修改`pyproject.toml`文件并不能生效, 因为还依赖于`poetry.lock`

可使用`poetry add {xxx}`进行添加

### 注意事项
#### 需要链接外网
```
HTTPSConnectionPool(host='files.pythonhosted.org', port=443): Max retries exceeded with url: /packages/17/61/32c3ab8951142e061587d957226b5683d1387fb22d95b4f69186d92616d1/typing_extensions-4.0.0-py3-none-any.whl (Caused by ProxyError('Cannot connect to proxy.', ConnectionResetError(54, 'Connection reset by peer')))

HTTPSConnectionPool(host='pypi.org', port=443): Max retries exceeded with url: /pypi/colorama/0.4.4/json (Caused by ProxyError('Cannot connect to proxy.', ConnectionResetError(54, 'Connection reset by peer')))
```

#### 需要安装ssl
```
SSLError

  HTTPSConnectionPool(host='pypi.org', port=443): Max retries exceeded with url: /pypi/importlib-metadata/4.2.0/json (Caused by SSLError(SSLEOFError(8, 'EOF occurred in violation of protocol (_ssl.c:1129)')))
```
该问题可通过安装openssl解决:
```bash
pip install ndg-httpsclient
pip install pyopenssl
pip install pyasn1
```

## CI WorkFlows
[workflows](https://github.com/IanVzs/py-muti-scrcpy/tree/main/.github/workflows)

### pypi token
- 注册pypi账号
- 进入账号管理中心[这里](https://pypi.org/manage/account/)
- 找见`API tokens`创建新token或者使用旧的，随个人
- 在GitHub项目配置中找到Action secrets管理[这里](https://github.com/IanVzs/py-muti-scrcpy/settings/secrets/actions)
- Repository secrets 中加入`PYPI_TOKEN` 因为`WorkFlows`中使用的是`PYPI_TOKEN` 见[POETRY_PYPI_TOKEN_PYPI: ${{ secrets.PYPI_TOKEN }}](https://github.com/IanVzs/py-muti-scrcpy/blob/main/.github/workflows/publish.yml#L64)
