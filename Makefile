.DEFAULT_GOAL:=help

## Variables
ROOT_DIR != pwd
TERRAFORM_BIN != which terraform
TERRAFORM_DOCS_BIN != which terraform-docs

DOCKER_TFLINT_VERSION ?= latest
DOCKER_TFSEC_VERSION ?= latest

## Targets
help: ## Show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

init: ## Initializes the Terraform configuration
	$(TERRAFORM_BIN) init

fmt: ## Formats the Terraform configuration
	$(TERRAFORM_BIN) fmt

validate: init ## Validates the Terraform configuration
	$(TERRAFORM_BIN) validate

docs: ## Generates the documentation. Creates a README.md file
	$(TERRAFORM_DOCS_BIN) . > README.md

lint:

lint-docker: ## Runs the dockerized version of tflint
	docker run --rm -v $(ROOT_DIR):/data:ro -t wata727/tflint:$(DOCKER_TFLINT_VERSION)

sec-docker: ## Runs the dockerized version of tfsec
	docker run --rm -it -v "$(ROOT_DIR):/src" liamg/tfsec:$(DOCKER_TFSEC_VERSION) /src
