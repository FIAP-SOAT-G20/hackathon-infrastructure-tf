resource "aws_eks_access_entry" "lab_role_access_entry" {
  cluster_name  = aws_eks_cluster.eks-cluster.name
  principal_arn = data.aws_iam_role.fiap_lab_role.arn
}

resource "aws_eks_access_policy_association" "admin_policy_association" {
  cluster_name     = aws_eks_cluster.eks-cluster.name
  principal_arn    = aws_eks_access_entry.lab_role_access_entry.principal_arn
  policy_arn       = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy" 
  access_scope {
    type = "cluster"
  }
}
