
# Makefile for deploying the California Housing Lambda pipeline

.PHONY: all clean init plan apply package test

# Variables
LAMBDA_ZIP=lambda/lambda_function.zip
TF_DIR=terraform
TF_VARS_FILE=terraform.tfvars

# Default target
all: init plan apply

# Initialize Terraform
init:
	@echo "Initializing Terraform..."
	cd $(TF_DIR) && terraform init

# Plan the Terraform deployment
plan:
	@echo "Planning Terraform deployment..."
	cd $(TF_DIR) && terraform plan -var-file=$(TF_VARS_FILE)

# Apply the Terraform deployment
apply:
	@echo "Applying Terraform deployment..."
	cd $(TF_DIR) && terraform apply -var-file=$(TF_VARS_FILE) -auto-approve

# Package the Lambda function
package:
	@echo "Packaging Lambda function..."
	tar.exe -a -c -f  $(LAMBDA_ZIP) .

# Test the Python code with pytest
test:
	@echo "Running tests with pytest..."
	pytest tests/

# Clean up
clean:
	@echo "Cleaning up..."
	rm -f $(LAMBDA_ZIP)
