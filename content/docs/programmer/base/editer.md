---
title: 编辑器使用
date: 2016-10-29 16:58:56
modified: 2022-01-18 11:34:00
categories: 杂谈
tags: 杂谈
slug: 
---

## Jupyter-Note
### 局域网访问
- 方法1: 
    - 使用`jupyter notebook --generate-config`生成配置文件
    - 修改配置文件中`c.NotebookApp.allow_root`(因为安卓用的Termux跑的,所以伪root),`c.NotebookApp.ip`这样就能通过局域网和`Token`访问了
    - 如果想要使用密码(长期使用局域网的话),可以使用`from notebook.auth import passwd;passwd()`生成加密密码,配置到`c.NotebookApp.password`
- 方法2:
    - 如果只是临时的,那传入运行命令肯定最好了,如下可以使用如下格式:
```bash
jupyter-notebook --allow-root --ip=0.0.0.0
```
### 自动补全
1. 安装插件: `pip install jupyter_contrib_nbextensions -i https://pypi.tuna.tsinghua.edu.cn/simple`(此命令包含代理)
2. 到`Nbextensions`中将`Disable`改为`Enable`
3. 开始

## Vim
![vim](https://tse4-mm.cn.bing.net/th/id/OIP.RsJpt9plNxxlrxA9yV-OVwHaHa?pid=ImgDet&rs=1)
### vim 查看日志中文乱码(2021)

#### .bash_profile
```
export LC_ALL=en_US.utf-8
```
#### .vimrc
```
 set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
 set termencoding=utf-8
 set encoding=utf-8
```
双管齐下, 一个解决`系统`配置, 一个解决`vim`配置
### 中文乱码问题(2018)
在`.bash_profile`中增加
```
export LANG=zh_CN.utf8
export LC_ALL=zh_CN.utf8
```
即可增加中文支持。   不过，还是
```
export LANG=en_US.utf8
export LC_ALL=en_US.utf8
```
比较香，因为中文字体很难看…
^_^: 
    2019年5月5日19点46分

## `vscode` `vs code`
### venv
#### Python
`Command Palette...`(`Ctrl+Shift+p`)
```
>Python: Select Interpreter
```

然后选择就好了.

----

当然不会那么安逸(`.vscode/launch.json`)
2022-01-18 11：34

----
#### `.vscode/launch.json`配置(图形化都是骗人的)
```
{
    // Use IntelliSense to learn about possible attributes.
    // Hover to view descriptions of existing attributes.
    // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Python: Current File", // 自定义名称
            "type": "python",
            "pythonPath": "{配置python解释器路径}",
			//调试程序时的工作目录，一般为${workspaceRoot}即代码所在目录
            "cwd": "${workspaceRoot}",
            "request": "launch",
            "program": "${file}", // 可直接指定文件
            "console": "integratedTerminal"
        }
    ]
}
```

## 三兄弟
### 查看文本 列
```bash
awk -F ',' '{print $NF}'
```
- `,` 分隔符
- `$NF` 末尾 同理也可 `$1`
- `$1, $3` 表示1列+3列,并不含2列

### find + vim 查找打开一条龙
```bash
find * -name "*wd.csv" -exec vim {} \;
```
来自`find --help`的解释: `-exec COMMAND ; -exec COMMAND {} + -ok COMMAND ;`
`-exec`兼容多条命令, `bash`监控`;`,但`find`也用`;`中断,所以在`bash`运行需要转义一层....也就变成了`\;`

### Grep
#### 排除某(些)文件(夹)
##### 文件:
`--exclude=`
##### 文件类型:
```
 grep "get_wx_mapping" . -r --exclude=*.{log,}
```
`{}`中貌似必须有`,`， 也就是说必须传入为列表， 不然不生效， 倒和`Python`的`tuple`类型有些相像。
##### 文件夹:
`--exclude-dir=`

```bash
个:
grep "get_wx_mapping" . -r --exclude-dir=log
些:
grep "get_wx_mapping" . -r --exclude-dir={log,__pycache__}
```
