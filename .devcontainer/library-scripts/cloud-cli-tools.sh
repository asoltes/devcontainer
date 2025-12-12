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
    echo "complete -C '$aws_completer_path' aws" >> /home/vscode/.bashrc
    echo "AWS CLI autocompletion setup complete!"
fi


# Installing SAM CLI
echo "Installing SAM CLI"
wget https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip
unzip aws-sam-cli-linux-x86_64.zip -d sam-installation
./sam-installation/install
sam --version
rm -rf aws-sam-cli-linux-x86_64.zip sam-installation

# Append AWS profile switcher function to .bashrc
cat >> /home/vscode/.zshrc <<'EOF'
function ax() {
    if [ -z "$1" ]; then
        export AWS_PROFILE="ctp-dev"
    else
        export AWS_PROFILE="$1"
    fi
    echo "Activating AWS profile: $AWS_PROFILE"
    if ! aws sts get-caller-identity --profile "$AWS_PROFILE" >/dev/null 2>&1; then
        echo "Session invalid or expired. Logging in..."
        aws sso login --profile "$AWS_PROFILE"
    fi
    echo "Switched to AWS profile: $AWS_PROFILE"
}
EOF

# Create directories for credentials
mkdir -p /home/vscode/.aws

# Set proper ownership
chown -R vscode:vscode /home/vscode/.aws
echo "Cloud CLI tools installation complete!"
