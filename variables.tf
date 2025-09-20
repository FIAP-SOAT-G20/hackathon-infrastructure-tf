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
    Project     = "hackathon"
    Terraform   = "true"
    Environment = "prod"
    Region      = "us-east-1"
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

variable "elasticache_engine" {
  description = "ElastiCache engine (redis or memcached)"
  type        = string
  default     = "redis"
  validation {
    condition     = contains(["redis", "memcached"], var.elasticache_engine)
    error_message = "Engine must be either 'redis' or 'memcached'."
  }
}

variable "elasticache_node_type" {
  description = "ElastiCache node type"
  type        = string
  default     = "cache.t3.micro"
}

variable "elasticache_port" {
  description = "Port number for ElastiCache"
  type        = number
  default     = 6379
}
variable "lambda_image_uri" {
  description = "URI of the Lambda container image"
  type        = string
  default     = "905417995957.dkr.ecr.us-east-1.amazonaws.com/hackathon-lambda-job-starter:latest"
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


variable "sqs_queues" {
  description = "Map of SQS queue configurations"
  type = map(object({
    name                        = string
    delay_seconds               = number
    message_retention_seconds   = number
    visibility_timeout_seconds  = number
    fifo_queue                  = optional(bool)
    content_based_deduplication = optional(bool)
    tags                        = optional(map(string))
    sns_topic_arn               = optional(string)
  }))
  default = {
    "video-uploaded" = {
      name                        = "video-uploaded"
      delay_seconds               = 0
      message_retention_seconds   = 1209600 # 14 days
      visibility_timeout_seconds  = 60
      fifo_queue                  = false
      content_based_deduplication = false
      tags = {
        Purpose = "Receives an event from S3 when a video is uploaded"
      }
    }
    "notification" = {
      name                        = "video-status-notification.fifo"
      delay_seconds               = 0
      message_retention_seconds   = 1209600 # 14 days
      visibility_timeout_seconds  = 60
      fifo_queue                  = true
      content_based_deduplication = true
      tags = {
        Purpose = "Receives an event from SNS when a video has its status updated and sends a notification to users"
      }
    }
    "video-status-updated.fifo" = {
      name                        = "video-status-updated.fifo"
      delay_seconds               = 0
      message_retention_seconds   = 1209600 # 14 days
      visibility_timeout_seconds  = 60
      fifo_queue                  = true
      content_based_deduplication = true
      tags = {
        Purpose = "Receives events when video status is updated"
      }
    }
  }
}

variable "sns_topics" {
  description = "Map of SNS topic configurations"
  type = map(object({
    name = string
    tags = optional(map(string))
  }))
  default = {
    "video-status-updated" = {
      name = "video-status-updated"
      tags = {
        Purpose = "Sends a notification to users when a video has its status updated"
      }
    }
  }
}

variable "s3_bucket_video_processor" {
  description = "Map of S3 bucket configurations"
  type        = string
  default     = "fiapx-10soat-g21"
}
