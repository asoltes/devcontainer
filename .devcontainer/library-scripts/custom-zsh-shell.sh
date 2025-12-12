#!/usr/bin/env bash
echo "Installing common utilities and dependencies..."
apt-get update
export DEBIAN_FRONTEND=noninteractive
apt-get -y install --no-install-recommends \
    fontconfig

# wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/RobotoMono.zip
# mkdir -p ~/.local/share/fonts/
# unzip RobotoMono.zip -d ~/.local/share/fonts/RobotoMono
# fc-cache -f -v
# rm RobotoMono.zip

git clone https://github.com/powerline/fonts.git
cd fonts
./install.sh
cd .. && rm -rf fonts

# oh-my-zsh plugins
zsh -c 'git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-/home/vscode/.oh-my-zsh/custom}/themes/powerlevel10k'
echo 'source /home/vscode/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme' >>/home/vscode/.zshrc

# Set timezone to Asia/Manila
sudo ln -sf /usr/share/zoneinfo/Asia/Manila /etc/localtime