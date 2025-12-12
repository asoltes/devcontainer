# Devcontainer

## Getting Started
Create `.devcontainer/.devcontainer.json` in target repo with the following minimal configuration and make sure to update the tag to get the latest update.

```json
// For format details, see https://aka.ms/devcontainer.json. For config options, see the
// README at: https://github.com/devcontainers/templates/tree/main/src/ubuntu
{
  "name": "devcontainer",
  // Or use a Dockerfile or Docker Compose file. More info: https://containers.dev/guide/dockerfile
  "image": "devcontainer",

  // Features to add to the dev container. More info: https://containers.dev/features.
  // "features": {},

  // Use 'forwardPorts' to make a list of ports inside the container available locally.
  // "forwardPorts": [],

  // Use 'postCreateCommand' to run commands after the container is created.
  // "postCreateCommand": "uname -a",
  "postAttachCommand": "bash",

  // Configure tool-specific properties.
  "customizations": {
    "vscode": {
      "settings": {
        "telemetry.telemetryLevel": "off"
      },
      // Add the IDs of extensions you want installed when the container is created.
      "extensions": []
    }
  }

  // Uncomment to connect as root instead. More info: https://aka.ms/dev-containers-non-root.
  // "remoteUser": "root"
}

```

## Manual Devcontainer Prebuilt
Login to CTP AWS Shared Account via SSO and Login in ECR
```

aws ecr get-login-password --region ap-southeast-1 | docker login --username AWS --password-stdin 565827786978.dkr.ecr.ap-southeast-1.amazonaws.com
```
Copy Certificate file /usr/local/share/ca-certificates/*.crt to .devcontainer/certs/zscaler.crt
```
make certs 
```
### Build Prebuilt devcontainer
Always change the version number

```
npm install -g @devcontainers/cli
devcontainer build --workspace-folder . --push true --image-name 565827786978.dkr.ecr.ap-southeast-1.amazonaws.com/ci/devcontainer:terraform-v1.0.0
```
## Tools and Vscode Extensions

### Tools

| Tool | Version |
|------|---------|
| TERRAFORM_VERSION | 1.14.1 |
| TERRAFORM_DOCS_VERSION | 0.20.0 |
| TFSEC_VERSION | 1.28.14 |
| TERRASCAN_VERSION | 1.19.9 |
| TFLINT_VERSION | 0.60.0 |
| TFLINT_AWS_RULESET_VERSION | 0.23.1 |
| TERRAGRUNT_VERSION | 0.50.1 |
| TERRATEST_VERSION | 0.49.0 |
| INFRACOST_VERSION | 0.10.41 |
| CHECKOV_VERSION | 3.2.439 |
| KUBECTL | v1.34.3 |
| ARGOCD | v3.2.1+8c4ab63 |
| ANSIBLE | 2.17.14 |
| COOKIECUTTER | 2.6.0 |
| PYTHON | 3.10.12 |
| AWS CLI | 2.32.14 |
| AWS SAM | 1.150.1 |

### VSCODE Extension

| Extension |
|-----------|
| hashicorp.terraform |
| run-at-scale.terraform-doc-snippets |
| redhat.vscode-yaml |
| eamodio.gitlens |
| donjayamanne.githistory |
| mhutchie.git-graph |
| ms-vscode-remote.remote-containers |
| ms-vscode-remote.remote-ssh |
| ms-vscode-remote.remote-ssh-edit |
| streetsidesoftware.code-spell-checker |
| yzhang.markdown-all-in-one |
| davidanson.vscode-markdownlint |
| timonwong.shellcheck |
| ms-python.python |
| ms-python.vscode-pylance |
| docker.docker |
| ms-azuretools.vscode-containers |
