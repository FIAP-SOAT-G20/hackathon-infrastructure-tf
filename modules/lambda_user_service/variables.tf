variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "lambda_image_uri" {
  description = "URI of the Lambda container image"
  type        = string
}

variable "lambda_memory" {
  description = "Lambda memory in MB"
  type        = number
  default     = 512
}

variable "lambda_timeout" {
  description = "Lambda timeout in seconds"
  type        = number
  default     = 60
}

variable "environment_variables" {
  description = "Environment variables for the Lambda function"
  type        = map(string)
  default     = {}
}

variable "log_retention_days" {
  description = "Number of days to retain CloudWatch logs"
  type        = number
  default     = 14
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "users_table_name" {
  description = "Name of the users DynamoDB table"
  type        = string
}

variable "ids_table_name" {
  description = "Name of the IDs DynamoDB table"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "jwt_secret" {
  description = "JWT secret for token signing"
  type        = string
  sensitive   = true
}

variable "jwt_expiration" {
  description = "JWT token expiration duration"
  type        = string
  default     = "24h"
}