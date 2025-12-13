ARG VARIANT="jammy"

# ---------------------
# Builder stage: install tools
# ---------------------
FROM mcr.microsoft.com/vscode/devcontainers/base:0-${VARIANT} AS builder

# Set versions as build args
ARG TERRAFORM_VERSION="1.14.1"
ARG TERRAFORM_DOCS_VERSION="0.20.0"
ARG TFLINT_VERSION="0.60.0"
ARG TFLINT_AWS_RULESET_VERSION="0.23.1"
ARG INFRACOST_VERSION="0.10.41"
ARG ANSIBLE_VERSION="2.12.3"
ARG HELM_VERSION="4.0.2"
# ARG CHECKOV_VERSION="3.2.439"
# ARG TERRAGRUNT_VERSION="0.50.1"
# ARG TERRATEST_VERSION="0.49.0"
# ARG TERRASCAN_VERSION="1.19.9"

# Copy library scripts
COPY library-scripts/*.sh /tmp/library-scripts/
RUN chmod +x /tmp/library-scripts/*.sh

USER root

# Install base utils (builder only)
RUN bash /tmp/library-scripts/common-utils.sh

# Install DevOps tools (Terraform stack, K8s, security, etc.)
RUN /tmp/library-scripts/devops-tools.sh \
    "${TERRAFORM_VERSION}" \
    "${TERRAFORM_DOCS_VERSION}" \
    "${TFLINT_VERSION}" \
    "${TFLINT_AWS_RULESET_VERSION}" \
    "${INFRACOST_VERSION}" \
    "${ANSIBLE_VERSION}" \
    "${HELM_VERSION}"
RUN apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# ---------------------
# Final stage: copy only runtime assets
# ---------------------
FROM mcr.microsoft.com/vscode/devcontainers/base:0-${VARIANT}

USER root

# Bring library scripts for minimal runtime setup
COPY --from=builder /tmp/library-scripts /tmp/library-scripts
RUN chmod +x /tmp/library-scripts/*.sh

# Minimal common runtime utilities (python, pip, zsh, etc.)
RUN bash /tmp/library-scripts/common-utils.sh

# Optional shell customizations (fonts/theme)
RUN /tmp/library-scripts/custom-zsh-shell.sh

# Copy CLI binaries and assets from builder to reduce final size
COPY --from=builder /usr/local/bin/terraform /usr/local/bin/terraform
COPY --from=builder /usr/local/bin/terraform-docs /usr/local/bin/terraform-docs
COPY --from=builder /usr/local/bin/tflint /usr/local/bin/tflint
COPY --from=builder /usr/local/bin/infracost /usr/local/bin/infracost
COPY --from=builder /usr/local/bin/argocd /usr/local/bin/argocd
COPY --from=builder /usr/local/bin/kubectl /usr/local/bin/kubectl
COPY --from=builder /usr/local/bin/helm /usr/local/bin/helm
COPY --from=builder /usr/local/go /usr/local/go

# COPY --from=builder /usr/local/bin/terratest /usr/local/bin/terratest
# COPY --from=builder /usr/local/bin/terragrunt /usr/local/bin/terragrunt
# COPY --from=builder /usr/local/bin/tfsec /usr/local/bin/tfsec
# COPY --from=builder /usr/local/bin/terrascan /usr/local/bin/terrascan
# COPY --from=builder /usr/local/bin/terratest /usr/local/bin/terratest

# AWS CLI and SAM CLI: install in final stage to preserve runtime layout
RUN /tmp/library-scripts/cloud-cli-tools.sh

# Pre-commit, ansible and cookiecutter
RUN /tmp/library-scripts/pip-tools.sh

# Trivy (installed via apt in builder; copy binary)
COPY --from=builder /usr/bin/trivy /usr/local/bin/trivy

# TFLint config/plugins created by builder scripts
COPY --from=builder /home/vscode/.tflint.hcl /home/vscode/.tflint.hcl
COPY --from=builder /home/vscode/.tflint.d /home/vscode/.tflint.d
RUN chown -R vscode:vscode /home/vscode/.tflint.d /home/vscode/.tflint.hcl || true

# Zsh configs
COPY dotfiles/.zshrc /home/vscode/.zshrc
COPY dotfiles/.p10k.zsh /home/vscode/.p10k.zsh
RUN chown vscode:vscode /home/vscode/.zshrc /home/vscode/.p10k.zsh \
    && chmod 644 /home/vscode/.zshrc /home/vscode/.p10k.zsh

# Project scripts and configuration
COPY scripts /home/vscode/.devcontainer/scripts
COPY config /home/vscode/.devcontainer/config
RUN chmod +x /home/vscode/.devcontainer/scripts/*.sh \
    && chown -R vscode:vscode /home/vscode/.devcontainer

# Terraform plugin cache
RUN mkdir -p /home/vscode/.terraform.d/plugin-cache \
    && chown -R vscode:vscode /home/vscode/.terraform.d

# Credential dirs
RUN mkdir -p /home/vscode/.aws \
    && mkdir -p /home/vscode/.ssh \
    && chown -R vscode:vscode /home/vscode/.aws \
    && chown -R vscode:vscode /home/vscode/.ssh \
    && chmod 700 /home/vscode/.ssh

# Post-start script
COPY post-start.sh /usr/local/bin/post-start
RUN chmod +x /usr/local/bin/post-start

# Clean up apt caches and temporary scripts to reduce final image size
RUN apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/library-scripts

# Switch back to vscode user
USER vscode
