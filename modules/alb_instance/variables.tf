variable "project_name" {
  default = "hackathon-alb"
}

variable "cidr_block" {
  type    = string
  default = "172.31.0.0/16"
}

variable "common_tags" {
  type = map(string)
  default = {
    Name        = "hackathon-alb"
    Environment = "dev"
    Project     = "hackathon"
  }
}

variable "region" {
  default = "us-east-1"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs where the RDS instances will be deployed"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where the RDS instances will be deployed"
}