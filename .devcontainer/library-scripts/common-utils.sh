#!/usr/bin/env bash
set -e
# Install common packages
echo "Installing common utilities and dependencies..."
apt-get update
export DEBIAN_FRONTEND=noninteractive
apt-get -y install --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    curl \
    git \
    gnupg \
    jq \
    lsb-release \
    make \
    software-properties-common \
    unzip \
    vim \
    wget \
    zip \
    pipx \
    ripgrep \
    unzip \
    python3 \
    python3-pip \
    python-is-python3

# Install pre-commit
echo "Installing pre-commit..."
python3 -m pip install --upgrade pip
pip3 install --no-cache-dir pre-commit

# Create directory for Terraform plugin cache
mkdir -p /home/vscode/.terraform.d/plugin-cache
chown -R vscode:vscode /home/vscode/.terraform.d

# Create SSH directory
mkdir -p /home/vscode/.ssh
chown -R vscode:vscode /home/vscode/.ssh
chmod 700 /home/vscode/.ssh

echo "Common utilities installation complete!"

#Install cookiecutter
python3 -m pip install cookiecutter
pipx ensurepath --force


# # Powerline fonts for zsh theme
# git clone https://github.com/powerline/fonts.git
# cd fonts
# ./install.sh
# cd .. && rm -rf fonts
# # Clone powerlevel10k theme
# zsh -c 'git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k'
# export ZSH_THEME="powerlevel10k/powerlevel10k"
