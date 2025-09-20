# EKS Outputs
output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks_instance.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint of the EKS cluster"
  value       = module.eks_instance.cluster_endpoint
}

output "cluster_ca_certificate" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = module.eks_instance.cluster_ca_certificate
}

output "cluster_token" {
  description = "Token for EKS cluster authentication"
  value       = module.eks_instance.cluster_token
  sensitive   = true
}

# VPC Outputs
output "vpc_id" {
  description = "ID of the VPC"
  value       = module.eks_instance.vpc_id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = module.eks_instance.vpc_cidr
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.eks_instance.private_subnet_ids
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.eks_instance.public_subnet_ids
}

# RDS Outputs
output "rds_postgres_hackathon_endpoint" {
  description = "DNS endpoint of the hackathon RDS instance"
  value       = module.rds_instance.rds_postgres_hackathon_endpoint
}

output "rds_postgres_hackathon_db_name" {
  description = "Database name of the hackathon RDS instance"
  value       = module.rds_instance.rds_postgres_hackathon_db_name
}
