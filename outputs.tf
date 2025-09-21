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

# ElastiCache Outputs
output "elasticache_cluster_id" {
  description = "ElastiCache cluster ID"
  value       = module.elasticache_instance.elasticache_cluster_id
}

output "elasticache_cluster_address" {
  description = "ElastiCache cluster address"
  value       = module.elasticache_instance.elasticache_cluster_address
}

output "elasticache_cluster_port" {
  description = "ElastiCache cluster port"
  value       = module.elasticache_instance.elasticache_cluster_port
}

output "elasticache_engine" {
  description = "ElastiCache engine"
  value       = module.elasticache_instance.elasticache_engine
}

# S3 Outputs
output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = module.s3_instance.s3_bucket_name
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = module.s3_instance.s3_bucket_arn
}

output "s3_bucket_id" {
  description = "ID of the S3 bucket"
  value       = module.s3_instance.s3_bucket_id
}

# DynamoDB Outputs
output "users_table_name" {
  description = "Name of the users DynamoDB table"
  value       = module.dynamodb_instance.users_table_name
}

output "users_table_arn" {
  description = "ARN of the users DynamoDB table"
  value       = module.dynamodb_instance.users_table_arn
}

output "ids_table_name" {
  description = "Name of the IDs DynamoDB table"
  value       = module.dynamodb_instance.ids_table_name
}

output "ids_table_arn" {
  description = "ARN of the IDs DynamoDB table"
  value       = module.dynamodb_instance.ids_table_arn
}

# User Service Lambda Outputs
output "user_service_lambda_function_name" {
  description = "Name of the User Service Lambda function"
  value       = module.lambda_user_service.lambda_function_name
}

output "user_service_lambda_arn" {
  description = "ARN of the User Service Lambda function"
  value       = module.lambda_user_service.lambda_arn
}

output "user_service_lambda_invoke_arn" {
  description = "Invoke ARN of the User Service Lambda function"
  value       = module.lambda_user_service.lambda_invoke_arn
}

# API Gateway Outputs
output "api_gateway_url" {
  description = "URL of the User Service API Gateway"
  value       = module.api_gateway_instance.api_gateway_url
}

output "api_gateway_id" {
  description = "ID of the User Service API Gateway"
  value       = module.api_gateway_instance.api_gateway_id
}

output "api_gateway_stage_name" {
  description = "Stage name of the User Service API Gateway"
  value       = module.api_gateway_instance.stage_name
}

# SQS Outputs
output "sqs_queue_urls" {
  description = "Map of SQS queue names to their URLs"
  value       = module.sqs_instance.sqs_queue_urls
}

output "sqs_queue_arns" {
  description = "Map of SQS queue names to their ARNs"
  value       = module.sqs_instance.sqs_queue_arns
}
