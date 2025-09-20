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

variable "sqs_queues" {
  description = "Map of SQS queue configurations"
  type = map(object({
    name                          = string
    delay_seconds                = number
    message_retention_seconds    = number
    visibility_timeout_seconds   = number
    fifo_queue                   = optional(bool)
    content_based_deduplication  = optional(bool)
    tags                         = optional(map(string))
    sns_topic_arn                = optional(string)
    s3_bucket_arn                = optional(string)
  }))
}