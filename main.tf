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