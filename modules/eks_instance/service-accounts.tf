resource "kubernetes_service_account" "lambda_job_starter" {
  metadata {
    name = "lambda-job-starter"
  }
}