data "aws_iam_role" "fiap_lab_role" {
  name = "LabRole"
}

data "aws_iam_role" "voclabs_role" {
  name = "voclabs"
}

data "aws_eks_cluster" "eks_cluster" {
  name       = var.project_name
  depends_on = [aws_eks_cluster.eks-cluster]
}

data "aws_eks_cluster_auth" "auth" {
  name = aws_eks_cluster.eks-cluster.name
}

provider "kubernetes" {
  host                   = aws_eks_cluster.eks-cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks-cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.auth.token
}

