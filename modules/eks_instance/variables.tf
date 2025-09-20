variable "region" {
  default = "us-east-1"
}

variable "project_name" {
  default = "hackathon-eks-cluster"
}

variable "lab_role" {
  description = "Lab role ARN retrieved dynamically from AWS"
  type        = string
  default     = null
}

variable "access_config" {
  default = "API_AND_CONFIG_MAP"
}

variable "node_group" {
  default = "fiap"
}

variable "instance_type" {
  default = "t3.medium"
}

variable "principal_arn" {
  description = "Principal ARN retrieved dynamically from AWS"
  type        = string
  default     = null
}

variable "policy_arn" {
  default = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
}

variable "cidr_block" {
  type    = string
  default = "172.31.0.0/16"
}

variable "tags" {
  type = map(string)
  default = {
    Name        = "hackathon-k8s"
    Environment = "dev"
    Project     = "hackathon"
  }
}
