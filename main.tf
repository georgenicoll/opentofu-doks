terraform {
    required_providers {
      kubernetes = {
        source = "hashicorp/kubernetes"
        version = "2.23.0"
      }
    }
}

provider "kubernetes" {
    config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "tofu_tests" {
    metadata {
      name = "tofu-experiments"
    }
}

resource "kubernetes_deployment" "nginx" {
    metadata {
      name = "nginx"
      namespace = kubernetes_namespace.tofu_tests.metadata.0.name
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
              name = "nginx"
              image = "nginx:latest"
              port {
                container_port = 80
              }
            }
          }
        }
    }
}
