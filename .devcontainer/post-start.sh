#!/usr/bin/env sh
set -e

# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

# Load environment variables
if [ -f "/home/vscode/.devcontainer/config/terraform.env" ]; then
    echo "Loading Terraform environment variables..."
    set -a
    # shellcheck disable=SC1091
    . "/home/vscode/.devcontainer/config/terraform.env"
    set +a
fi

# Make scripts executable
chmod +x /home/vscode/.devcontainer/scripts/*.sh

# Display welcome message
clear
# shellcheck disable=SC2059
printf "\e[0;32mTerraform Development Environment: $(basename "$PWD")\e[0m\n\n"

# Display installed tools and versions
echo "=== Installed Tools ==="
echo "Terraform: $(terraform --version | head -n 1)"
echo "AWS CLI: $(aws --version)"
echo "SAM CLI: $(sam --version)"
echo "Terraform Docs: $(terraform-docs --version)"
echo "TFLint: $(tflint --version)"
echo "Kubectl: $(kubectl version --client=true)"
echo "ArgoCD: $(argocd version --client)"
echo "Ansible: $(ansible --version | head -n 1)"
# echo "TFSec: $(tfsec --version)"
# echo "Terrascan: $(terrascan version)"
# echo "Terragrunt: $(terragrunt --version)"
# echo "Terratest: v$(terratest | head -n 1 | cut -d 'v' -f 2)"
# echo "Checkov: $(checkov --version)"
echo ""

# Display environment information
echo "=== Environment Information ==="
echo "Working Directory: $(pwd)"
echo "User: $(whoami)"

# Display authentication 9status
echo "=== Multiple Authentication Commands ==="
echo "AWS: Run '.devcontainer/scripts/aws-auth.sh' to authenticate"
echo "Custom AX Function: Run ax (profile) | example: ax ctp-dev"
echo "OhmyZSHPlugin: asp (profile) | example: asp ctp-dev ato authenticate"
echo ""

# Display helpful commands
echo "=== Helpful Commands ==="
echo "terraform init - Initialize a Terraform working directory"
echo "terraform plan - Generate and show an execution plan"
echo "terraform apply - Builds or changes infrastructure"
echo "terraform validate - Validates the Terraform files"
echo "terraform fmt - Rewrites config files to canonical format"
echo "pre-commit run --all-files - Run pre-commit hooks on all files"
# echo "npx semantic-release --dry-run - Test semantic-release process without publishing"
echo ""

# Programming Language Versions
echo "=== Programming Language Versions ==="
echo "Python: $(python3 --version)"
echo "Go: $(go version)"

# Display container information if available
if command -v devcontainer-info &> /dev/null; then
    devcontainer-info
fi
