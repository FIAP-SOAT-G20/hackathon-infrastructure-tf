resource "kubernetes_service" "ms-1" {
  metadata {
    name = "ms-1"
  }
  spec {
    selector = { app = "ms-1" }
    port {
      port        = 80
      target_port = 8080
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_ingress_v1" "microservices" {
  metadata {
    name = "microservices-ingress"
    annotations = {
      "kubernetes.io/ingress.class"           = "alb"
      "alb.ingress.kubernetes.io/scheme"      = "internet-facing"
      "alb.ingress.kubernetes.io/target-type" = "ip"
    }
  }

  spec {
    rule {
      http {
        path {
          path      = "/api"
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = kubernetes_service.ms-1.metadata[0].name
              port { number = 80 }
            }
          }
        }
      }
    }
  }
}