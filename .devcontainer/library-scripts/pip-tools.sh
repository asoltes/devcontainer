#!/usr/bin/env bash
set -e
ANSIBLE_VERSION=${1:-"2.12.3"}


# Install pre-commit
echo "Installing pre-commit..."
python3 -m pip install --upgrade pip
pip3 install --no-cache-dir pre-commit

# Ansible installation
echo "Installing Ansible v${ANSIBLE_VERSION}..."
python3 -m pip install ansible

#Install cookiecutter
python3 -m pip install cookiecutter
pipx ensurepath --force


echo "other-cli-tools"

if [ ! -d "$HOME/.fzf" ]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
fi

"$HOME/.fzf/install" --all
