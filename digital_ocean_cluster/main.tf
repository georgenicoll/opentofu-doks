variable "do_token" {
  type        = string
  description = "The token to use when running commands against the digital ocean API"
  default     = "<needs to be overridden>"
}

# terraform {
#     required_providers {
#       kubernetes = {
#         source = "hashicorp/kubernetes"
#         version = "2.23.0"
#       }
#     }
# }

provider "digitalocean" {
  token = var.do_token
}

locals {
  cluster_name    = "tofu-doks"
  region          = "lon1"
  k8_version      = "1.30"
}

data "digitalocean_kubernetes_versions" "k8_version" {
  version_prefix = "${local.k8_version}."
}

resource "digitalocean_kubernetes_cluster" "tofu_doks" {
  name         = local.cluster_name
  region       = local.region
  version      = data.digitalocean_kubernetes_versions.k8_version.latest_version
  auto_upgrade = true

  maintenance_policy {
    start_time = "04:00"
    day        = "sunday"
  }

  node_pool {
    name       = "autoscale-worker-pool"
    size       = "s-2vcpu-2gb"
    auto_scale = true
    min_nodes  = 1
    max_nodes  = 5
  }
}

output "raw_kube_config" {
  value = digitalocean_kubernetes_cluster.tofu_doks.kube_config[0].raw_config
}

output "cluster_name" {
  value = digitalocean_kubernetes_cluster.tofu_doks.name
}

output "cluster_endpoint" {
  value = digitalocean_kubernetes_cluster.tofu_doks.endpoint
}

output "cluster_token" {
  value = digitalocean_kubernetes_cluster.tofu_doks.kube_config[0].token
}

output "cluster_ca_certificate" {
  value = digitalocean_kubernetes_cluster.tofu_doks.kube_config[0].cluster_ca_certificate
}
