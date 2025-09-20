variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment"
  type        = string
  default     = "dev"
}

variable "topic_names" {
  description = "Map of SQS queue configurations"
  type = map(object({
    name                          = string
    tags                         = optional(map(string))
  }))
}