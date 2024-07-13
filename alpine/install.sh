#!/bin/bash
echo ">>>>>>>>>>安装初始化>>>>>>>>>>>"
# 0. 配置 apk 镜像源
echo ">>> 配置apk镜像 >>>"
sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
apk update

# 1. 安装 nvm
echo ">>> 安装nvm >>>"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

cat >> ~/.zshrc<< EOF
export NVM_DIR="\$HOME/.nvm"
[ -s "\$NVM_DIR/nvm.sh" ] && \. "\$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "\$NVM_DIR/bash_completion" ] && \. "\$NVM_DIR/bash_completion"  # This loads nvm bash_completion
EOF

# 2. 安装 go
echo ">>> 安装golang >>>"
apk add go
# 创建目录
mkdir -p ~/go/src ~/go/bin ~/go/pkg
# 配置环境变量
cat >> ~/.zshrc << EOF
export GOPATH=~/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:/usr/lib/go/bin:$GOBIN
export GO111MODULE=on
export GOPROXY=https://goproxy.cn,direct
EOF
# 验证
go version

# 3. 安装 rust
echo ">>> 安装rust >>>"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# 配置镜像源
cat >> ~/.cargo/config << EOF
[source.crates-io]
registry = "https://github.com/rust-lang/crates.io-index"

replace-with = 'tuna'
[source.tuna]
registry = "https://mirrors.tuna.tsinghua.edu.cn/git/crates.io-index.git"

#replace-with = 'ustc'
#[source.ustc]
#registry = "git://mirrors.ustc.edu.cn/crates.io-index"

[net]
git-fetch-with-cli = true
EOF

# 创建 rust 代码库
mkdir -p ~/Rust
cat >> ~/.zshrc << EOF
RS=~/Rust
EOF

# 4. 将默认shell 设置为 zsh
sudo chsh -s $(which zsh) # 需要重启

# 5. 安装 lazygit
echo ">>> 安装lazygit >>>"
apk add lazygit

cat >> ~/.zshrc << EOF
alias lg=lazygit
EOF

# 6. 安装 tmux,配置
echo ">>> 安装tmux >>>"
apk add tmux

# 7. 安装 zsh 插件
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
git clone https://github.com/wting/autojump.git $ZSH_CUSTOM/plugins/autojump

# 引入插件
sed -i 's/plugins=(git)/plugins=(git zsh-syntax-highlighting zsh-autosuggestions autojump)/g' ~/.zshrc

# 8. 安装 neovim,下载配置
apk add neovim
git clone https://github.com/NvChad/starter ~/.config/nvim

# 9. 安装 bat
apk add bat

# 重新加载配置文件
source ~/.zshrc
# 重启
sudo reboot