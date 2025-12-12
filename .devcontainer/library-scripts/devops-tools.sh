#!/usr/bin/env bash
set -e

# This script installs Terraform and related tools

# Versions
TERRAFORM_VERSION=${1:-"1.14.1"}
TERRAFORM_DOCS_VERSION=${2:-"0.20.0"}
TFSEC_VERSION=${3:-"1.28.14"}
TERRASCAN_VERSION=${4:-"1.19.9"}
TFLINT_VERSION=${5:-"0.60.0"}
TFLINT_AWS_RULESET_VERSION=${6:-"0.23.1"}
TERRAGRUNT_VERSION=${7:-"0.50.1"}
TERRATEST_VERSION=${8:-"0.49.0"}
INFRACOST_VERSION=${9:-"0.10.41"}
CHECKOV_VERSION=${10:-"3.2.439"}
ANSIBLE_VERSION=${11:-"2.12.3"}
HELM_VERSION=${12:-"4.0.2"}

echo "Installing Terraform v${TERRAFORM_VERSION}..."
curl -sSL -o /tmp/terraform.zip "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
unzip -qq /tmp/terraform.zip -d /tmp
sudo mv /tmp/terraform /usr/local/bin/
rm -f /tmp/terraform.zip

echo "Installing terraform-docs v${TERRAFORM_DOCS_VERSION}..."
curl -sSLo /tmp/terraform-docs.tar.gz "https://github.com/terraform-docs/terraform-docs/releases/download/v${TERRAFORM_DOCS_VERSION}/terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-amd64.tar.gz"
tar -xzf /tmp/terraform-docs.tar.gz -C /tmp
sudo mv /tmp/terraform-docs /usr/local/bin/
rm -f /tmp/terraform-docs.tar.gz

echo "Installing tfsec v${TFSEC_VERSION}..."
curl -sSLo /tmp/tfsec "https://github.com/aquasecurity/tfsec/releases/download/v${TFSEC_VERSION}/tfsec-linux-amd64"
sudo mv /tmp/tfsec /usr/local/bin/
sudo chmod +x /usr/local/bin/tfsec

echo "Installing terrascan v${TERRASCAN_VERSION}..."
curl -sSLo /tmp/terrascan.tar.gz "https://github.com/tenable/terrascan/releases/download/v${TERRASCAN_VERSION}/terrascan_${TERRASCAN_VERSION}_Linux_x86_64.tar.gz"
tar -xzf /tmp/terrascan.tar.gz -C /tmp
sudo mv /tmp/terrascan /usr/local/bin/
rm -f /tmp/terrascan.tar.gz

echo "Installing tflint v${TFLINT_VERSION}..."
curl -sSLo /tmp/tflint.zip "https://github.com/terraform-linters/tflint/releases/download/v${TFLINT_VERSION}/tflint_linux_amd64.zip"
unzip -qq /tmp/tflint.zip -d /tmp
sudo mv /tmp/tflint /usr/local/bin/
rm -f /tmp/tflint.zip

echo "Installing TFLint AWS ruleset v${TFLINT_AWS_RULESET_VERSION}..."
mkdir -p ~/.tflint.d/plugins
curl -sSLo /tmp/tflint-aws-ruleset.zip "https://github.com/terraform-linters/tflint-ruleset-aws/releases/download/v${TFLINT_AWS_RULESET_VERSION}/tflint-ruleset-aws_linux_amd64.zip"
unzip -qq /tmp/tflint-aws-ruleset.zip -d ~/.tflint.d/plugins
rm -f /tmp/tflint-aws-ruleset.zip

echo "Installing Terragrunt v${TERRAGRUNT_VERSION}..."
curl -sSLo /tmp/terragrunt "https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64"
sudo mv /tmp/terragrunt /usr/local/bin/
sudo chmod +x /usr/local/bin/terragrunt

curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sudo sh -s -- -b "/usr/local/bin" "${TRIVY_VERSION}"

echo "Installing Terratest v${TERRATEST_VERSION}..."
# Terratest is a Go library, so we'll set an environment variable to track the version
echo "export TERRATEST_VERSION=${TERRATEST_VERSION}" >> /home/vscode/.bashrc

# Install Go if not already installed
if ! command -v go &> /dev/null; then
    echo "Installing Go (required for Terratest)..."
    GO_VERSION="1.20.5"
    curl -sSLo /tmp/go.tar.gz "https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz"
    sudo tar -C /usr/local -xzf /tmp/go.tar.gz
    echo "export PATH=$PATH:/usr/local/go/bin" >> /home/vscode/.bashrc
    echo "export PATH=$PATH:$HOME/go/bin" >> /home/vscode/.bashrc
    rm -f /tmp/go.tar.gz
fi

# Create a simple wrapper script for terratest
cat > /tmp/terratest << EOF
#!/bin/bash
echo "Terratest v${TERRATEST_VERSION}"
echo "Terratest is a Go library for testing infrastructure code."
echo "To use Terratest, add it to your Go project:"
echo "go get github.com/gruntwork-io/terratest@v${TERRATEST_VERSION}"
EOF
sudo mv /tmp/terratest /usr/local/bin/
sudo chmod +x /usr/local/bin/terratest

echo "Installing Infracost v${INFRACOST_VERSION}..."
curl -sSLo /tmp/infracost.tar.gz "https://github.com/infracost/infracost/releases/download/v${INFRACOST_VERSION}/infracost-linux-amd64.tar.gz"
tar -xzf /tmp/infracost.tar.gz -C /tmp
sudo mv /tmp/infracost-linux-amd64 /usr/local/bin/infracost
rm -f /tmp/infracost.tar.gz

echo "Installing Trivy"
# curl -sfL "https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh" | sudo sh -s -- -b "/usr/local/bin v${TRIVY_VERSION}"
apt-get update && sudo apt-get install -y wget apt-transport-https gnupg lsb-release bundler
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee -a /etc/apt/sources.list.d/trivy.list
apt-get update
apt-get install -y trivy

echo "Installing Checkov v${CHECKOV_VERSION}..."
pip uninstall -y pycares aiodns
pip install pycares==4.4.0 aiodns==3.1.1
pip3 install "checkov==${CHECKOV_VERSION}"

# Create .tflint.hcl config file
mkdir -p /home/vscode/.tflint.d
cat > /home/vscode/.tflint.hcl << EOF
plugin "aws" {
  enabled = true
}
EOF

# Ansible installation
echo "Installing Ansible v${ANSIBLE_VERSION}..."
python3 -m pip install ansible

# ARGO CD installation
# Download Linux AMD64 binary
curl -sSL -o argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
# Make it executable and move to PATH
chmod +x argocd
sudo mv argocd /usr/local/bin/argocd

# kubectl installation
echo "Installing kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm -rf kubectl

# Install helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-4
chmod 700 get_helm.sh
./get_helm.sh
rm -rf get_helm.sh

# Set ownership for the config file
chown -R vscode:vscode /home/vscode/.tflint.d


echo "Terraform tools installation complete!"
