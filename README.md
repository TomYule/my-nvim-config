#nvim配置Java开发配置


NVIM v0.8.0-dev预览版安装
```
https://www.jianshu.com/p/96941f00d004
```

nvim插件基于packer
```
https://github.com/wbthomason/packer.nvim
```
需要电脑安装`git python pip nodejs npm java`

需要如下软件 有的是电脑端 有的是npm  有的是pip
```
prettierd shfmt shellharden fixjson black isort stylua google_java_format eslint_d flake8 tsc shellcheck zsh eslint_d gitrebase refactoring proselint shellcheck dictionary
```
npm
``` 
npm install -g prettierd  fixjson eslint_d shellcheck tsc
```

package
``` 
pacman -S shfmt shellharden  zsh
```

pip 安装
``` 
sudo wget https://bootstrap.pypa.io/get-pip.py
python get-pip.py
```
pip

``` 
pip install flake8 black isort

```


winbar 需要0.8.0版本支持
```
https://github.com/fgheng/winbar.nvim
```