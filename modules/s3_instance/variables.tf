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

variable "s3_bucket_name" {
  description = "Name of the S3 bucket that will send messages to the SQS queues"
  type = string
}

variable "sqs_queue_arn" {
  description = "ARN of the SQS queue that will receive messages from the S3 buckets"
  type        = string
}

variable "sqs_queue_url" {
  description = "URL of the SQS queue that will receive messages from the S3 buckets"
  type        = string
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Project   = "hackathon"
    Terraform = "true"
  }
}
