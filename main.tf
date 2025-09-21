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

data "aws_eks_cluster" "cluster" {
  name = module.eks_instance.cluster_name
  depends_on = [module.eks_instance]
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks_instance.cluster_name
  depends_on = [module.eks_instance]
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
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

  project_name     = var.project_name
  environment      = var.environment
  lambda_image_uri = var.lambda_image_uri
  lambda_memory    = var.lambda_memory
  lambda_timeout   = var.lambda_timeout

}


module "sns_instance" {
  source = "./modules/sns_instance"

  environment = var.environment
  topic_names = var.sns_topics
}

locals {
  transformed_sqs_queues = {
    for key, value in var.sqs_queues :
    key => merge(value,
        key == "video-status-notification.fifo" ? {
        sns_topic_arn = module.sns_instance.sns_topic_arns["video-status-updated"],
      } : {},
        key == "video-status-updated.fifo" ? {
        sns_topic_arn = module.sns_instance.sns_topic_arns["video-status-updated"],
      } : {},
        key == "video-uploaded" ? {
        s3_bucket_arn = "arn:aws:s3:::${var.s3_bucket_video_processor_raw_videos}",
      } : {}
    )
  }
}

module "sqs_instance" {
  source = "./modules/sqs_instance"

  environment = var.environment
  sqs_queues  = local.transformed_sqs_queues

  depends_on = [module.sns_instance]
}


module "s3_instance" {
  source = "./modules/s3_instance"

  aws_region                  = var.aws_region
  environment                 = var.environment
  s3_bucket_name              = var.s3_bucket_video_processor_raw_videos
  sqs_queue_arn               = module.sqs_instance.sqs_queue_arns["video-uploaded"]
  sqs_queue_policy_dependency = module.sqs_instance.s3_to_sqs_policies

  depends_on = [module.sqs_instance]
}

# DynamoDB for User Service
module "dynamodb_instance" {
  source = "./modules/dynamodb_instance"

  project_name = var.project_name
  environment  = var.environment
  common_tags  = var.common_tags
}

# Parameter Store for Configuration
module "parameter_store" {
  source = "./modules/parameter_store"

  project_name   = var.project_name
  environment    = var.environment
  jwt_secret     = var.jwt_secret
  jwt_expiration = var.jwt_expiration
  common_tags    = var.common_tags
}

# Lambda User Service
module "lambda_user_service" {
  source = "./modules/lambda_user_service"

  project_name                 = var.project_name
  environment                  = var.environment
  lambda_image_uri             = var.lambda_user_service_image_uri
  lambda_memory                = var.lambda_user_service_memory
  lambda_timeout               = var.lambda_user_service_timeout
  users_table_name             = module.dynamodb_instance.users_table_name
  ids_table_name               = module.dynamodb_instance.ids_table_name
  aws_region                   = var.aws_region
  jwt_secret_parameter_name    = module.parameter_store.jwt_secret_parameter_name
  jwt_expiration_parameter_name = module.parameter_store.jwt_expiration_parameter_name
  environment_variables        = var.lambda_user_service_environment_variables
  common_tags                  = var.common_tags

  depends_on = [module.dynamodb_instance, module.parameter_store]
}


# API Gateway for Services
module "api_gateway_instance" {
  source = "./modules/api_gateway_instance"

  project_name              = var.project_name
  environment               = var.environment
  stage_name                = var.api_gateway_stage_name
  lambda_function_name      = module.lambda_user_service.lambda_function_name
  lambda_invoke_arn         = module.lambda_user_service.lambda_invoke_arn
  video_service_alb_dns     = module.alb_instance.alb_dns_name
  common_tags               = var.common_tags

  depends_on = [module.lambda_user_service, module.alb_instance]
}
