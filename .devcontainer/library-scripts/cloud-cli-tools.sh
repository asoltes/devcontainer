#!/usr/bin/env bash
set -e

# This script installs AWS CLI

# Install AWS CLI v2
echo "Installing AWS CLI v2..."
curl -sSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o /tmp/awscliv2.zip
unzip -qq /tmp/awscliv2.zip -d /tmp
sudo /tmp/aws/install
rm -rf /tmp/aws /tmp/awscliv2.zip

# Additional aws cli autocompletion setup
aws_completer_path=$(which aws_completer)
if [ -f "$aws_completer_path" ]; then
    echo "Setting up AWS CLI autocompletion..."
    complete -C "$aws_completer_path" aws
    echo "complete -C '$aws_completer_path' aws" >> /home/vscode/.zshrc
    echo "AWS CLI autocompletion setup complete!"
fi

# Installing SAM CLI
echo "Installing SAM CLI"
wget https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip
unzip aws-sam-cli-linux-x86_64.zip -d sam-installation
./sam-installation/install
sam --version
rm -rf aws-sam-cli-linux-x86_64.zip sam-installation

# Ansible installation
python3 -m pip install ansible

# Bash My AWS installation
git clone https://github.com/bash-my-aws/bash-my-aws.git "${BMA_HOME:-/home/vscode/.bash-my-aws}"
export PATH="$PATH:${BMA_HOME:-/home/vscode/.bash-my-aws}/bin"
# shellcheck disable=SC1091
source "${BMA_HOME:-/home/vscode/.bash-my-aws}"/aliases
# For ZSH users, uncomment the following two lines:
autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit
# shellcheck disable=SC1091
source "${BMA_HOME:-/home/vscode/.bash-my-aws}"/bash_completion.sh

# Create directories for credentials
mkdir -p /home/vscode/.aws

# Set proper ownership
chown -R vscode:vscode /home/vscode/.aws
echo "Cloud CLI tools installation complete!"
