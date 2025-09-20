resource "aws_elasticache_subnet_group" "main" {
  name        = "${var.project_name}-${var.environment}-elasticache-subnet-group"
  subnet_ids  = var.subnet_ids
  description = "Subnet group for ElastiCache instances in the ${var.project_name} project"

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-elasticache-subnet-group"
  })
}

resource "aws_elasticache_parameter_group" "main" {
  count       = var.parameter_group_name == null ? 1 : 0
  family      = var.parameter_group_family != null ? var.parameter_group_family : (var.engine == "redis" ? "redis7" : "memcached1.6")
  name        = "${var.project_name}-${var.environment}-${var.engine}-params"
  description = "Parameter group for ${var.engine} in ${var.project_name} project"

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-${var.engine}-params"
  })
}

resource "aws_elasticache_cluster" "main" {
  cluster_id           = "${var.project_name}-${var.environment}-cache"
  engine               = var.engine
  node_type            = var.node_type
  num_cache_nodes      = var.num_cache_nodes
  parameter_group_name = var.parameter_group_name != null ? var.parameter_group_name : aws_elasticache_parameter_group.main[0].name
  port                 = var.port
  subnet_group_name    = aws_elasticache_subnet_group.main.name
  security_group_ids   = [aws_security_group.elasticache_sg.id]
  engine_version       = var.engine_version
  maintenance_window   = var.maintenance_window

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-cache"
  })
}
