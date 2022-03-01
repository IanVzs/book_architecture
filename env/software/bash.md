# Bash
## 自动补全
linux中使用bash_completion工具进行自动不全，在某些发行版或者版本中make或者git没有Tab自动补全，这时在Github上找一个bash_completion文件放在相应位置就可以了。
```bash
sudo cp bash_completion /usr/share/bash-completion/bash_completion
source /usr/share/bash-completion/bash_completion
```
