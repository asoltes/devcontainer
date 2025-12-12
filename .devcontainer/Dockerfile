ARG VARIANT="jammy"
FROM mcr.microsoft.com/vscode/devcontainers/base:0-${VARIANT}

COPY certs/zscaler.crt /usr/local/share/ca-certificates/zscaler.crt
RUN update-ca-certificates

# Set versions as arguments
ARG TERRAFORM_VERSION="1.14.1"
ARG TERRAFORM_DOCS_VERSION="0.20.0"
ARG TFSEC_VERSION="1.28.14"
ARG TERRASCAN_VERSION="1.19.9"
ARG TFLINT_VERSION="0.60.0"
ARG TFLINT_AWS_RULESET_VERSION="0.23.1"
ARG TERRAGRUNT_VERSION="0.50.1"
ARG TERRATEST_VERSION="0.49.0"
ARG INFRACOST_VERSION="0.10.41"
ARG CHECKOV_VERSION="3.2.439"
ARG HELM_VERSION="4.0.2"   

# Copy library scripts
COPY library-scripts/*.sh /tmp/library-scripts/
RUN chmod +x /tmp/library-scripts/*.sh

# Install common utilities and dependencies
USER root
RUN bash /tmp/library-scripts/common-utils.sh

# Install cloud CLI tools
RUN /tmp/library-scripts/cloud-cli-tools.sh

# Install DevOps tools
RUN /tmp/library-scripts/devops-tools.sh \
    "${TERRAFORM_VERSION}" \
    "${TERRAFORM_DOCS_VERSION}" \
    "${TFSEC_VERSION}" \
    "${TERRASCAN_VERSION}" \
    "${TFLINT_VERSION}" \
    "${TFLINT_AWS_RULESET_VERSION}" \
    "${TERRAGRUNT_VERSION}" \
    "${TERRATEST_VERSION}" \
    "${INFRACOST_VERSION}" \
    "${CHECKOV_VERSION}" \
    "${ANSIBLE_VERSION}"

# Install custom Zsh shell configuration
RUN /tmp/library-scripts/custom-zsh-shell.sh

COPY dotfiles/.zshrc /home/vscode/.zshrc
COPY dotfiles/.p10k.zsh /home/vscode/.p10k.zsh
RUN chown vscode:vscode /home/vscode/.zshrc /home/vscode/.p10k.zsh \
    && chmod 644 /home/vscode/.zshrc /home/vscode/.p10k.zsh

# Copy scripts and configuration
COPY scripts /home/vscode/.devcontainer/scripts
COPY config /home/vscode/.devcontainer/config
RUN chmod +x /home/vscode/.devcontainer/scripts/*.sh
RUN chown -R vscode:vscode /home/vscode/.devcontainer

# Set up Terraform plugin cache directory
RUN mkdir -p /home/vscode/.terraform.d/plugin-cache \
    && chown -R vscode:vscode /home/vscode/.terraform.d

# Set up credential directories
RUN mkdir -p /home/vscode/.aws \
    && mkdir -p /home/vscode/.ssh \
    && chown -R vscode:vscode /home/vscode/.aws \
    && chown -R vscode:vscode /home/vscode/.ssh \
    && chmod 700 /home/vscode/.ssh

# # Clean up
# RUN apt-get clean -y \
#     && rm -rf /var/lib/apt/lists/* \
#     && rm -rf /tmp/library-scripts

# Copy post-start script
COPY post-start.sh /usr/local/bin/post-start
RUN chmod +x /usr/local/bin/post-start

# Switch back to vscode user
USER vscode
