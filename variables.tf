variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "hackathon"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
  default = "dev"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Project   = "hackathon"
    Terraform = "true"
  }
}

variable "rds_db_username" {
  description = "Master username for the PostgreSQL RDS instances"
  type        = string
  default     = "postgres"
}

variable "rds_db_password" {
  description = "Master password for the PostgreSQL RDS instances"
  type        = string
  sensitive   = true
  default     = "postgres"
}
