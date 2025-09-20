# Hackathon Infrastructure Terraform

[![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)](https://aws.amazon.com/)
[![Kubernetes](https://img.shields.io/badge/kubernetes-%23326ce5.svg?style=for-the-badge&logo=kubernetes&logoColor=white)](https://kubernetes.io/)

This repository contains Terraform infrastructure code for the FIAP PostTech Hackathon project. It provisions a complete AWS cloud infrastructure including an EKS cluster, RDS PostgreSQL database, ElastiCache Redis cluster, and Application Load Balancer (ALB) with best practices for security, scalability, and maintainability.

## 📋 Table of Contents

- [Architecture](#-architecture)
- [Prerequisites](#-prerequisites)
- [Project Structure](#-project-structure)
- [Configuration](#-configuration)
- [Usage](#-usage)
- [Outputs](#-outputs)
- [Contributing](#-contributing)
- [License](#-license)

## 🏗️ Architecture

This infrastructure includes the following AWS components:

- **Amazon EKS (Elastic Kubernetes Service)**: Managed Kubernetes cluster for container orchestration
- **Amazon RDS PostgreSQL**: Managed relational database service
- **Amazon ElastiCache Redis**: Managed in-memory caching service for improved application performance
- **Application Load Balancer (ALB)**: Load balancer for distributing incoming traffic
- **VPC with Public/Private Subnets**: Network isolation and security
- **Security Groups**: Network access control
- **IAM Roles and Policies**: Identity and access management

### Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                         AWS VPC                            │
│                                                             │
│  ┌─────────────────┐              ┌─────────────────┐      │
│  │  Public Subnet  │              │  Public Subnet  │      │
│  │                 │              │                 │      │
│  │      ALB        │              │      ALB        │      │
│  └─────────────────┘              └─────────────────┘      │
│           │                                │               │
│  ┌─────────────────┐              ┌─────────────────┐      │
│  │ Private Subnet  │              │ Private Subnet  │      │
│  │                 │              │                 │      │
│  │   EKS Nodes     │              │   EKS Nodes     │      │
│  │                 │              │                 │      │
│  │   RDS Instance  │              │  ElastiCache    │      │
│  │                 │              │                 │      │
│  └─────────────────┘              └─────────────────┘      │
└─────────────────────────────────────────────────────────────┘
```

## 📋 Prerequisites

Before using this infrastructure, ensure you have:

- **Terraform** >= 1.0 installed ([Download](https://www.terraform.io/downloads))
- **AWS CLI** v2 configured with appropriate credentials ([Setup Guide](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html))
- **kubectl** installed for Kubernetes cluster management ([Install Guide](https://kubernetes.io/docs/tasks/tools/))
- **Make** utility for using the provided Makefile commands
- **AWS IAM permissions** for creating EKS, RDS, VPC, and related resources

### Required AWS Permissions

Your AWS credentials should have permissions for:
- EC2 (VPC, Subnets, Security Groups, Load Balancers)
- EKS (Cluster management, Node groups)
- RDS (Database instances)
- ElastiCache (Cache clusters, Subnet groups, Parameter groups)
- IAM (Roles and policies for EKS)
- S3 (For Terraform state backend)

## 📁 Project Structure

```
.
├── main.tf                    # Main Terraform configuration
├── variables.tf               # Variable definitions
├── outputs.tf                # Output definitions
├── Makefile                  # Automation commands
├── README.md                 # This file
└── modules/
    ├── alb_instance/         # Application Load Balancer module
    │   ├── alb.tf
    │   ├── outputs.tf
    │   ├── provider.tf
    │   ├── sg.tf
    │   └── variables.tf
    ├── eks_instance/         # EKS cluster module
    │   ├── data.tf
    │   ├── eks.tf
    │   ├── kubernetes.tf
    │   ├── outputs.tf
    │   ├── provider.tf
    │   ├── sg.tf
    │   ├── variables.tf
    │   └── vpc.tf
    ├── elasticache_instance/ # ElastiCache Redis module
    │   ├── main.tf
    │   ├── outputs.tf
    │   ├── provider.tf
    │   ├── sg.tf
    │   └── variables.tf
    └── rds_instance/         # RDS PostgreSQL module
        ├── main.tf
        ├── outputs.tf
        └── variables.tf
```

## ⚙️ Configuration

### Environment Variables

The infrastructure supports different environments through variables:

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `project_name` | Name of the project | `hackathon` | No |
| `environment` | Environment (dev/staging/prod) | `dev` | No |
| `aws_region` | AWS region | `us-east-1` | No |
| `common_tags` | Common tags for all resources | See variables.tf | No |
| `rds_db_username` | RDS master username | `postgres` | No |
| `rds_db_password` | RDS master password | `postgres` | Yes* |
| `elasticache_engine` | ElastiCache engine (redis/memcached) | `redis` | No |
| `elasticache_node_type` | ElastiCache node type | `cache.t3.micro` | No |
| `elasticache_port` | ElastiCache port number | `6379` | No |

*Required in production environments. Use AWS Secrets Manager or similar for production deployments.

### Backend Configuration

The Terraform state is stored in an S3 backend:
- **Bucket**: `video-terraform-state-soat-g21-hackathon`
- **Key**: `terraform.tfstate`
- **Region**: `us-east-1`

Ensure this S3 bucket exists and you have appropriate permissions.

## 🚀 Usage

### Quick Start

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd hackathon-infrastructure-tf
   ```

2. **Initialize Terraform**
   ```bash
   make tf-init
   ```

3. **Review the execution plan**
   ```bash
   make tf-plan
   ```

4. **Apply the infrastructure**
   ```bash
   make tf-apply
   ```

5. **Configure kubectl for EKS**
   ```bash
   make aws-eks-auth
   ```

### Available Make Commands

| Command | Description |
|---------|-------------|
| `make help` | Show available commands |
| `make tf-init` | Initialize Terraform |
| `make tf-plan` | Show Terraform execution plan |
| `make tf-apply` | Apply Terraform configuration |
| `make tf-destroy` | Destroy all resources |
| `make aws-eks-auth` | Update kubeconfig for EKS cluster |

### Manual Terraform Commands

If you prefer using Terraform directly:

```bash
# Initialize
terraform init

# Plan
terraform plan

# Apply
terraform apply

# Destroy
terraform destroy
```

### Custom Configuration

To customize the deployment, create a `terraform.tfvars` file:

```hcl
project_name = "my-hackathon"
environment  = "prod"
aws_region   = "us-west-2"

common_tags = {
  Project     = "my-hackathon"
  Environment = "prod"
  Owner       = "team-name"
  Terraform   = "true"
}

rds_db_username = "admin"
rds_db_password = "secure-password-here"

# ElastiCache Configuration
elasticache_engine    = "redis"
elasticache_node_type = "cache.t3.small"
elasticache_port      = 6379
```

## 📤 Outputs

After successful deployment, the following outputs are available:

### EKS Cluster
- `cluster_name`: Name of the EKS cluster
- `cluster_endpoint`: API server endpoint
- `cluster_ca_certificate`: Certificate for cluster communication
- `cluster_token`: Authentication token (sensitive)

### VPC & Networking
- `vpc_id`: VPC identifier
- `vpc_cidr`: VPC CIDR block
- `private_subnet_ids`: Private subnet identifiers
- `public_subnet_ids`: Public subnet identifiers

### RDS Database
- `rds_postgres_hackathon_endpoint`: Database endpoint
- `rds_postgres_hackathon_db_name`: Database name

### ElastiCache
- `elasticache_cluster_id`: Cache cluster identifier
- `elasticache_cluster_address`: Cache cluster endpoint address
- `elasticache_cluster_port`: Cache cluster port
- `elasticache_engine`: Cache engine type (redis/memcached)

View outputs after deployment:
```bash
terraform output
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Style

- Follow Terraform best practices
- Use consistent naming conventions
- Add comments for complex configurations
- Update documentation when adding features

### Testing

Before submitting changes:
1. Run `terraform fmt` to format code
2. Run `terraform validate` to validate configuration
3. Test in a development environment first

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

**FIAP PostTech - Software Architecture Specialization**  
*Team G21 - 2025 Hackathon Project*
