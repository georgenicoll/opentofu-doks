variable "do_token" {
  type        = string
  description = "The token to use when running commands against the digital ocean API"
  default     = "<needs to be overridden>"
}

variable "kubeconfig_path" {
  type = string
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

resource "local_file" "kubeconfig" {
  content  = digitalocean_kubernetes_cluster.tofu_doks.kube_config.0.raw_config
  filename = var.kubeconfig_path
}

output "kubeconfig_path" {
  value = local_file.kubeconfig.filename
}

output "kubeconfig_context" {
  value = ""
}
