    resource "kubernetes_cluster_role" "lambda_job_starter" {
      metadata {
        name      = "lambda-job-starter-cluster-role"
      }
      rule {
        api_groups = ["batch"] # Core API group
        resources  = ["jobs"]
        verbs      = ["create", "get", "list", "watch", "delete", "patch", "update"]
      }
    }
