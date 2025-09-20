output "cluster_name" {
  value = aws_eks_cluster.eks-cluster.id
}

output "cluster_endpoint" {
  value = aws_eks_cluster.eks-cluster.endpoint
}

output "vpc_arn" {
  value = aws_vpc.hackathon_vpc.arn
}

output "vpc_id" {
  value = aws_vpc.hackathon_vpc.id
}

output "vpc_cidr" {
  value = aws_vpc.hackathon_vpc.cidr_block
}

output "security_group_id" {
  value = aws_security_group.sg.id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "lab_role_arn" {
  value = data.aws_iam_role.fiap_lab_role.arn
}

output "principal_arn" {
  value = data.aws_iam_role.voclabs_role.arn
}

output "cluster_ca_certificate" {
  value = aws_eks_cluster.eks-cluster.certificate_authority[0].data
}

output "cluster_token" {
  value     = data.aws_eks_cluster_auth.auth.token
  sensitive = true
}
