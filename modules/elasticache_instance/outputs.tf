output "elasticache_cluster_id" {
  description = "ElastiCache cluster ID"
  value       = aws_elasticache_cluster.main.cluster_id
}

output "elasticache_cluster_address" {
  description = "ElastiCache cluster address"
  value       = var.engine == "redis" && length(aws_elasticache_cluster.main.cache_nodes) > 0 ? aws_elasticache_cluster.main.cache_nodes[0].address : aws_elasticache_cluster.main.cluster_address
}

output "elasticache_cluster_port" {
  description = "ElastiCache cluster port"
  value       = aws_elasticache_cluster.main.port
}

output "elasticache_security_group_id" {
  description = "ElastiCache security group ID"
  value       = aws_security_group.elasticache_sg.id
}

output "elasticache_subnet_group_name" {
  description = "ElastiCache subnet group name"
  value       = aws_elasticache_subnet_group.main.name
}

output "elasticache_engine" {
  description = "ElastiCache engine"
  value       = aws_elasticache_cluster.main.engine
}

output "elasticache_engine_version" {
  description = "ElastiCache engine version"
  value       = aws_elasticache_cluster.main.engine_version
}
