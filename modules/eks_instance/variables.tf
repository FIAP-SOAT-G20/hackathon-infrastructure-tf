variable "region" {
  default = "us-east-1"
}

variable "project_name" {
  default = "ff-tech-challenge-eks-cluster"
}

variable "lab_role" {
  default = "arn:aws:iam::829401394278:role/LabRole"
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
  default = "arn:aws:iam::829401394278:role/voclabs"
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
    Name        = "tech-challenge-3-k8s"
    Environment = "dev"
    Project     = "tech-challenge"
  }
}
