resource "aws_security_group" "elasticache_sg" {
  name        = "${var.project_name}-${var.environment}-elasticache-sg"
  description = "Security group for ElastiCache cluster"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"] # Allow access from private subnets
    description = "ElastiCache access from VPC"
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
