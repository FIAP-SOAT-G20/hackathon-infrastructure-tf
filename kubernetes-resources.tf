# Kubernetes Cluster Role for Lambda Job Starter
resource "kubernetes_cluster_role" "lambda_job_starter" {
  metadata {
    name = "lambda-job-starter-cluster-role"
  }
  rule {
    api_groups = ["batch"] # batch API group
    resources  = ["jobs"]
    verbs      = ["create", "get", "list", "watch", "delete", "patch", "update"]
  }
}

# Kubernetes Service Account for Lambda Job Starter
resource "kubernetes_service_account" "lambda_job_starter" {
  metadata {
    name = "lambda-job-starter"
  }
}

# Kubernetes Cluster Role Binding for Lambda Job Starter
resource "kubernetes_cluster_role_binding" "lambda_job_starter" {
  metadata {
    name = "lambda-job-starter-cluster-role-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.lambda_job_starter.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.lambda_job_starter.metadata[0].name
  }
}
