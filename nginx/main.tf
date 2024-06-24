variable "kubeconfig_path" {
  type = string
}

variable "kubeconfig_context" {
  type = string
}

provider "kubernetes" {
  config_path = var.kubeconfig_path
  config_context = var.kubeconfig_context
}

locals {
  nginx_namespace = "nginx"
}

resource "kubernetes_namespace" "nginx_namespace" {
  metadata {
    name = local.nginx_namespace
  }

  # # Ensure that we need the tofu_doks cluster for this
  # depends_on = [
  #   root.digitalocean_kubernetes_cluster.tofu_doks
  # ]
}

resource "kubernetes_deployment" "nginx" {
  metadata {
    name      = "nginx"
    namespace = kubernetes_namespace.nginx_namespace.id
  }
  spec {
    replicas = 3
    selector {
      match_labels = {
        app = "nginx"
      }
    }
    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }
      spec {
        container {
          name  = "nginx"
          image = "nginx:latest"
          port {
            container_port = 80
          }
        }
      }
    }
  }
}
