SHELL:=/bin/sh
.PHONY: all

TF_BIN ?= terraform

help: ## this help
	@awk 'BEGIN {FS = ":.*?## ";  printf "Usage:\n  make \033[36m<target> \033[0m\n\nTargets:\n"} /^[a-zA-Z0-9_-]+:.*?## / {gsub("\\\\n",sprintf("\n%22c",""), $$2);printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

pre-commit: ## run pre-commit run -a
	pre-commit run -a

build-lambda-terminate-ec2: ## Build Golang lambda terminate ec2
	cd scripts/lambda_terminate_ec2_instances ;\
	bash build.sh

fmt: ## run terraform fmt --write=true -diff
	@terraform fmt --write=true -diff

docs: ## run terraform-docs markdown table --output-file README.md --output-mode inject .
	@terraform-docs markdown table --output-file README.md --output-mode inject .

security-code-analysis: ## run tfsec .
	@tfsec .
