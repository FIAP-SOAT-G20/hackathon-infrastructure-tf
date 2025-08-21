resource "aws_db_subnet_group" "main" {
  name       = "fiap-hackathon-subnet"
  subnet_ids = var.subnet_ids
  description = "Subnet group for RDS instances in the FIAP hackathon project"
  
  tags = {
    Name = "RdsSubnetGroup"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Allow PostgreSQL access"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "postgres_hackathon" {
  allocated_storage       = 20
  db_name                 = "video_10soat_g21_hackathon"
  engine                  = "postgres"
  engine_version          = "17.5"
  instance_class          = "db.t3.micro"
  username                = var.db_username
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.main.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  publicly_accessible     = true
  skip_final_snapshot     = true
  identifier              = "video-10soat-g21-hackathon"
  backup_retention_period = 7  
  multi_az                = false
  storage_type            = "gp3"
  apply_immediately       = true

  tags = {
    Name = "PostgresInstance"
  }
}
