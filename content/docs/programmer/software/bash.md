# Bash
Auther: Ian
## 自动补全
linux中使用bash_completion工具进行自动不全，在某些发行版或者版本中make或者git没有Tab自动补全，这时在Github上找一个bash_completion文件放在相应位置就可以了。
```bash
sudo cp bash_completion /usr/share/bash-completion/bash_completion
source /usr/share/bash-completion/bash_completion
```

## Powershell
命令历史存储在:
`C:\Users\{USERNAME}\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine`下 `ConsoleHost_history.txt`文件