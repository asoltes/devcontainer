SHELL := /bin/bash
.PHONY: certs

certs:
	@mkdir -p .devcontainer/certs
	cp -p /usr/local/share/ca-certificates/zscaler.crt .devcontainer/certs/zscaler.crt
