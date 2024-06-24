variable "kubeconfig_path" {
  type = string
}

terraform {
  required_providers {
    kind = {
      source = "tehcyx/kind"
      version = "0.5.1"
    }
  }
}

resource "kind_cluster" "cluster" {
  name = "tofu-cluster"
  wait_for_ready = true
}

resource "local_file" "kubeconfig" {
  source  = kind_cluster.cluster.kubeconfig_path
  filename = var.kubeconfig_path
}

output "kubeconfig_path" {
  value = local_file.kubeconfig.filename
}

output "kubeconfig_context" {
  value = "kind-tofu-cluster"
}
