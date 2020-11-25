.DEFAULT_GOAL:=help

# Variables
ROOT_DIR != pwd

DOCKER_TF_VERSION 	   ?= latest
DOCKER_TFLINT_VERSION  ?= latest
DOCKER_TFSEC_VERSION   ?= latest
DOCKER_TFDOCS_VERSION  ?= latest
DOCKER_CHECKOV_VERSION ?= latest
OPTIONS				   ?=		 # The options to be passed to the executed command

# Targets
help: ## Show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

init: ## Initializes the Terraform configuration
	docker run --rm --workdir /data -u 1000:1000 -v $(ROOT_DIR):/data hashicorp/terraform:$(DOCKER_TF_VERSION) init -input=false $(OPTIONS) /data

fmt: ## Formats the Terraform configuration
	docker run --rm -v $(ROOT_DIR):/data hashicorp/terraform:$(DOCKER_TF_VERSION) fmt $(OPTIONS) /data

validate: ## Validates the Terraform configuration
	docker run --rm hashicorp/terraform:$(DOCKER_TF_VERSION) validate $(OPTIONS)

docs: ## Generates the documentation. Creates a README.md file
	docker run --rm -v $(ROOT_DIR):/data:ro quay.io/terraform-docs/terraform-docs:$(DOCKER_TFDOCS_VERSION) /data > README.md

lint: ## Runs the dockerized version of tflint
	docker run --rm -v $(ROOT_DIR):/data:ro -t wata727/tflint:$(DOCKER_TFLINT_VERSION) $(OPTIONS)

security: ## Runs the dockerized version of tfsec
	docker run --rm -v $(ROOT_DIR):/data:ro liamg/tfsec:$(DOCKER_TFSEC_VERSION) /data $(OPTIONS)

checkov: ## Runs the dockerized version of checkov
	docker run --rm -v $(ROOT_DIR):/data:ro bridgecrew/checkov:$(DOCKER_CHECKOV_VERSION) -d /data $(OPTIONS)
