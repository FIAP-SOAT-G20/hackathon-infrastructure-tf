resource "aws_security_group" "elasticache_sg" {
  name        = "${var.project_name}-${var.environment}-elasticache-sg"
  description = "Security group for ElastiCache cluster"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block] # Allow access from VPC CIDR
    description = "ElastiCache access from VPC"
  }

  # Allow access from EKS security group if provided
  dynamic "ingress" {
    for_each = var.eks_security_group_id != null ? [1] : []
    content {
      from_port       = var.port
      to_port         = var.port
      protocol        = "tcp"
      security_groups = [var.eks_security_group_id]
      description     = "ElastiCache access from EKS nodes"
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-elasticache-sg"
  })
}
