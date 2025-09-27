AWS_EKS_CLUSTER_NAME=hackathon-eks-cluster
AWS_ACCOUNT_ID?=$$(aws sts get-caller-identity --query Account --output text)

# Looks at comments using ## on targets and uses them to produce a help output.
.PHONY: help
help: ALIGN=22
help: ## Print this message
    @echo "Usage: make <command>"
    @awk -F '::? .*## ' -- "/^[^':]+::? .*## /"' { printf "  make '$$(tput bold)'%-$(ALIGN)s'$$(tput sgr0)' - %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

.PHONY: tf-init
tf-init: ## Initialize Terraform
    @echo  "🟢 Initializing Terraform..."
    terraform init

.PHONY: tf-validate
tf-validate: ## Validate Terraform configuration
    @echo  "🟢 Validating Terraform configuration..."
    terraform validate

.PHONY: tf-plan
tf-plan: ## Show Terraform plan and save to file
    @echo  "🟢 Showing Terraform plan..."
    @echo "Using AWS Account ID: $(AWS_ACCOUNT_ID)"
    terraform plan -out=tfplan -var "aws_account_id=$(AWS_ACCOUNT_ID)"

.PHONY: tf-apply
tf-apply: ## Apply Terraform from saved plan
    @echo  "🟢 Applying Terraform..."
    @echo "Using AWS Account ID: $(AWS_ACCOUNT_ID)"
    terraform apply -input=false -auto-approve tfplan -var "aws_account_id=$(AWS_ACCOUNT_ID)"

.PHONY: tf-apply-direct
tf-apply-direct: ## Apply Terraform directly (without plan file)
    @echo  "🟢 Applying Terraform directly..."
    @echo "Using AWS Account ID: $(AWS_ACCOUNT_ID)"
    terraform apply -input=false -auto-approve -var "aws_account_id=$(AWS_ACCOUNT_ID)"

.PHONY: tf-destroy
tf-destroy: ## Destroy Terraform resources
    @echo  "🔴 Destroying Terraform resources..."
    @echo "Using AWS Account ID: $(AWS_ACCOUNT_ID)"
    terraform destroy -auto-approve -var "aws_account_id=$(AWS_ACCOUNT_ID)"


.PHONY: aws-eks-auth
aws-eks-auth: ## Update kubeconfig for the newly created EKS cluster
    @echo  "🟢 Updating kubeconfig for the EKS cluster..."
    aws eks update-kubeconfig --name $(AWS_EKS_CLUSTER_NAME)
