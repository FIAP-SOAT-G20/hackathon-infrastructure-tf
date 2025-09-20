variable "aws_region" {
  description = "AWS region to deploy SNS"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment"
  type        = string
  default     = "dev"
}

variable "sns_topic_name" {
  description = "Name of the SNS topic"
  type        = string
  default     = "payment-approved"
}

variable "sns_email_subscription" {
  description = "Email to subscribe to the topic"
  type        = string
  default     = "you@example.com"
}

