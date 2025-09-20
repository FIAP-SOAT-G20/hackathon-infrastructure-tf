AWS_EKS_CLUSTER_NAME=hackathon-eks-cluster

# Looks at comments using ## on targets and uses them to produce a help output.
.PHONY: help
help: ALIGN=22
help: ## Print this message
	@echo "Usage: make <command>"
	@awk -F '::? .*## ' -- "/^[^':]+::? .*## /"' { printf "  make '$$(tput bold)'%-$(ALIGN)s'$$(tput sgr0)' - %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

.PHONY: validate
validate: ## Validate Terraform configuration
	@echo  "🟢 Validating Terraform configuration..."
	terraform validate

.PHONY: tf-init
tf-init: ## Initialize Terraform
	@echo  "🟢 Initializing Terraform..."
	terraform init

.PHONY: tf-plan
tf-plan: ## Show Terraform plan
	@echo  "🟢 Showing Terraform plan..."
	terraform plan

.PHONY: tf-apply
tf-apply: ## Apply Terraform
	@echo  "🟢 Applying Terraform..."
	terraform apply -auto-approve

.PHONY: tf-destroy
tf-destroy: ## Destroy Terraform resources
	@echo  "🔴 Destroying Terraform resources..."
	terraform destroy -auto-approve


.PHONY: aws-eks-auth
aws-eks-auth: ## Update kubeconfig for the newly created EKS cluster
	@echo  "🟢 Updating kubeconfig for the EKS cluster..."
	aws eks update-kubeconfig --name $(AWS_EKS_CLUSTER_NAME)
