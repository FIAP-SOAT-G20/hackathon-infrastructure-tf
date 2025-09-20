resource "aws_eks_node_group" "eks-node" {
  cluster_name    = aws_eks_cluster.eks-cluster.name
  node_group_name = var.node_group
  node_role_arn   = data.aws_iam_role.fiap_lab_role.arn
  subnet_ids      = aws_subnet.private[*].id
  instance_types  = [var.instance_type]

  scaling_config {
    desired_size = 1
    min_size     = 1
    max_size     = 10
  }

  update_config {
    max_unavailable = 1
  }
}

resource "aws_eks_cluster" "eks-cluster" {
  name     = var.project_name
  role_arn = data.aws_iam_role.fiap_lab_role.arn

  vpc_config {
    subnet_ids              = aws_subnet.private[*].id
    security_group_ids      = [aws_security_group.sg.id]
    endpoint_public_access  = true
    endpoint_private_access = false
  }
}
