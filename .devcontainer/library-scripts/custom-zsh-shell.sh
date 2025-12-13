#!/usr/bin/env bash
echo "Installing common utilities and dependencies..."
apt-get update
export DEBIAN_FRONTEND=noninteractive
apt-get -y install --no-install-recommends \
    fontconfig

wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/RobotoMono.zip
mkdir -p ~/.local/share/fonts/
unzip RobotoMono.zip -d ~/.local/share/fonts/RobotoMono
fc-cache -f -v
rm RobotoMono.zip

# git clone https://github.com/powerline/fonts.git
# cd fonts
# ./install.sh
# cd .. && rm -rf fonts

# CURRENT_USER_FONT_PATH=~/.local/share/fonts/

# mkdir -p "$CURRENT_USER_FONT_PATH"

# curl -L https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf --output "${CURRENT_USER_FONT_PATH}MesloLGS NF Regular.ttf"
# curl -L https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf --output "${CURRENT_USER_FONT_PATH}MesloLGS NF Bold.ttf"
# curl -L https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf --output "${CURRENT_USER_FONT_PATH}MesloLGS NF Italic.ttf"
# curl -L https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf --output "${CURRENT_USER_FONT_PATH}MesloLGS NF Bold Italic.ttf"



# oh-my-zsh plugins
zsh -c 'git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-/home/vscode/.oh-my-zsh/custom}/themes/powerlevel10k'
echo 'source /home/vscode/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme' >>/home/vscode/.zshrc

# sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.5/zsh-in-docker.sh)" -- \
#     -p git \
#     -p https://github.com/zsh-users/zsh-autosuggestions \
#     -p https://github.com/zsh-users/zsh-completions \
#     -p https://github.com/zsh-users/history-substring-search \
#     -p aws \
#     -p z \
#     -t powerlevel10k \

if [ ! -d "$HOME/.fzf" ]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
fi

"$HOME/.fzf/install" --all