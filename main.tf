terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.16"
    }
  }

  backend "s3" {
    bucket = "video-terraform-state-soat-g21-hackathon"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = var.common_tags
  }
}

module "eks_instance" {
  source = "./modules/eks_instance"
}

module "rds_instance" {
  source = "./modules/rds_instance"

  aws_region  = var.aws_region
  environment = var.environment
  db_username = var.rds_db_username
  db_password = var.rds_db_password
  subnet_ids  = module.eks_instance.private_subnet_ids
  vpc_id      = module.eks_instance.vpc_id

  depends_on = [module.eks_instance]
}

module "alb_instance" {
  source = "./modules/alb_instance"

  project_name = var.project_name
  vpc_id       = module.eks_instance.vpc_id
  subnet_ids   = module.eks_instance.public_subnet_ids
  common_tags  = var.common_tags

  depends_on = [module.eks_instance]
}

module "elasticache_instance" {
  source = "./modules/elasticache_instance"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.eks_instance.vpc_id
  subnet_ids   = module.eks_instance.private_subnet_ids
  engine       = var.elasticache_engine
  node_type    = var.elasticache_node_type
  port         = var.elasticache_port
  common_tags  = var.common_tags

  depends_on = [module.eks_instance]
}

module "lambda_instance" {
  source = "./modules/lambda"

  project_name = var.project_name
  environment = var.environment
  lambda_image_uri = var.lambda_image_uri
  lambda_memory = var.lambda_memory
  lambda_timeout = var.lambda_timeout

  depends_on = [module.eks_instance]
}
