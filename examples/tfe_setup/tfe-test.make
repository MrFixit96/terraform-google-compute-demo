####################################################################################
#
#    Name:Makefile
#    Author: James Anderton <james@janderton.com>
#    Purpose: This file sets up the Terraform ENV and executes the  terraform commands
#             so as to build out a full Google Cloud Environment via Terraform and 
#             store the remote state in a gcp cloud storage bucket
#
#   REQUIREMENTS: make sure you have a "TFVARS FILE" named and located where "VARS"
#             in line 18 is pointing and have it named in the format prescribed.
#             answerfile-<PARENT_FOLDER>-<TENANT>.<USER>.tfvars where PARENT_FOLDER is
#             a directory consisting of "root files" that are calling  terraform modules
#             and TENANT is an arbitrary value like 001 that allows a user to have more
#             than one  terraform environment and $USER is the OS Environment variable 
#             pointing to who you currently are logged in as.
#
#####################################################################################
# Run everything in the same shell
.ONESHELL:
# Use Bash
.SHELL := /usr/bin/bash
# These are our rules to key on
.PHONY: apply destroy destroy-target plan-destroy plan plan-target prep

# Global Variables:
#
# VARS is used as an answerfile we'll pull everything else from
VARS=./terraform-demo.auto.tfvars
#
CURRENT_FOLDER=$(shell basename "$$(pwd)")
PARENT_FOLDER=$(shell basename "$$(echo $${PWD%/*})")
ENV=$(shell awk '$$1 == "env" {print $$NF}' ${VARS}|tr -d '"')
PROJECT=$(shell awk '$$1 == "state_project_name" {print $$NF}' ${VARS}|tr -d '"')
REGION=$(shell awk '$$1 == "region" {print $$NF}' ${VARS}|tr -d '"')
GCP_CREDENTIALS=$(shell awk '$$1 == "credential_file" {print $$NF}' ${VARS}|tr -d '"')
# Storing state to a google cloud storage bucket
STATE_BUCKET=$(shell awk '$$1 == "state_bucket_name" {print $$NF}' ${VARS}|tr -d '"')
GCLOUD_BUCKET=${STATE_BUCKET}
# Prefix is the directory to store the state file in
PREFIX=$(shell awk '$$1 == "prefix_${CURRENT_FOLDER}" {print $$NF}' ${VARS}|tr -d '"')
# Workspace is the file the state will be stored in
WORKSPACE=${ENV}-${PREFIX}
#
# Setting colors for the stderror output
BOLD=$(shell tput bold)
RED=$(shell tput setaf 1)
GREEN=$(shell tput setaf 2)
YELLOW=$(shell tput setaf 3)
RESET=$(shell tput sgr0)

# Take all available make targets and append the comments from after each ## and print it all to stdout
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# Make sure the proper ENV Variables are in place
set-env:
	@if [ -z ${ENV} ]; then \
		echo "$(BOLD)$(RED)ENV was not set$(RESET)"; \
		ERROR=1; \
	 fi
	@if [ -z $(REGION) ]; then \
		echo "$(BOLD)$(RED)REGION was not set$(RESET)"; \
		ERROR=1; \
	 fi
	@if [ -z ${GCP_CREDENTIALS} ]; then \
		echo "$(BOLD)$(RED)AWS_PROFILE was not set.$(RESET)"; \
		ERROR=1; \
	 fi
	@if [ ! -z $${ERROR} ] && [ $${ERROR} -eq 1 ]; then \
		echo "$(BOLD)Example usage: \`AWS_PROFILE=whatever ENV=demo REGION=us-east-2 make plan\`$(RESET)"; \
		exit 1; \
	 fi
	@if [ ! -f "${VARS}" ]; then \
		echo "$(BOLD)$(RED)Could not find variables file: ${VARS}$(RESET)"; \
		exit 1; \
	 fi
	@echo "$(BOLD)$(GREEN)Environment is ready for Terraforming"

prep: set-env ## Verify the Cloud Storage Bucket exisists and Prepare a new workspace (environment) if needed, configure the tfstate backend, update any modules, and switch to the workspace
	@echo "$(BOLD)Verifying that the GCloud Storage bucket ${GCLOUD_BUCKET} for remote state exists$(RESET)"
	@if ! gsutil ls -p ${PROJECT} gs://${GCLOUD_BUCKET} > /dev/null 2>&1 ; then \
		echo "$(RED)GCLOUD_BUCKET bucket ${GCLOUD_BUCKET} was not found. Please create a bucket with versioning enabled to store tfstate$(RESET)"; \
		exit 1; \
	 else
		echo "$(BOLD)$(GREEN)GCLOUD_BUCKET bucket ${GCLOUD_BUCKET} exists$(RESET)"; \
	 fi
	@echo "$(BOLD)Configuring the  terraform backend$(RESET)"
	@ terraform init \
		-force-copy \
		-upgrade \
		-verify-plugins=true \
		-backend=true \
		-backend-config="bucket=${GCLOUD_BUCKET}" \
		-backend-config="credentials=${GCP_CREDENTIALS}" \
		-backend-config="prefix=${PREFIX}"
	@echo "$(BOLD)Switching to workspace ${WORKSPACE}$(RESET)"
	@ terraform workspace select ${WORKSPACE} ||  terraform workspace new ${WORKSPACE}

plan: prep ## Show what  terraform thinks it will do
	@ terraform plan \
		-input=false \
		-refresh=true \
		-var-file="$(VARS)" \

plan-target: prep ## Shows what a plan looks like for applying a specific resource
	@echo "$(YELLOW)$(BOLD)[INFO]   $(RESET)"; echo "Example to type for the following question: module.rds.aws_route53_record.rds-master"
	@read -p "PLAN target: " DATA && \
		 terraform plan \
			-input=true \
			-refresh=true \
			-var-file="$(VARS)" \
			-target=$$DATA

plan-destroy: prep ## Creates a destruction plan.
	@ terraform plan \
		-input=false \
		-refresh=true \
		-destroy \
		-var-file="$(VARS)" \

apply: prep ## Have  terraform do the things. This will cost money.
	@TFE_LOG=DEBUG  terraform apply \
		-input=false \
                -auto-approve \
		-refresh=true \
		-var-file="$(VARS)" \

destroy: prep ## Destroy the things
	@ TF_WARN_OUTPUT_ERRORS=1  terraform destroy \
		-input=false \
                -auto-approve \
		-refresh=true \
		-var-file="$(VARS)" \

destroy-target: prep ## Destroy a specific resource. Caution though, this destroys chained resources.
	@echo "$(YELLOW)$(BOLD)[INFO] Specifically destroy a piece of Terraform data.$(RESET)"; echo "Example to type for the following question: module.rds.aws_route53_record.rds-master"
	@read -p "Destroy target: " DATA && \
		 terraform destroy \
		-input=false \
                -auto-approve \
		-refresh=true \
		-var-file=$(VARS) \
		-target=$$DATA

