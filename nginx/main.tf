variable "cluster_endpoint" {
  type = string
}

variable "cluster_token" {
  type = string
}

variable "cluster_ca_certificate" {
  type = string
}

provider "kubernetes" {
  host  = var.cluster_endpoint
  token = var.cluster_token
  cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
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
