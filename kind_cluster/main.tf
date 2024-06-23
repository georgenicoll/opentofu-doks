terraform {
  required_providers {
    kind = {
      source = "tehcyx/kind"
      version = "0.5.1"
    }
  }
}

resource "kind_cluster" "cluster" {
  name = "tofu_cluster"
  wait_for_ready = true
}

output "raw_kube_config" {
  value = kind_cluster.cluster.kubeconfig
}

output "cluster_name" {
  value = kind_cluster.cluster.name
}

output "cluster_endpoint" {
  value = kind_cluster.cluster.endpoint
}

output "cluster_token" {
  value = kind_cluster.cluster.???
}

output "cluster_ca_certificate" {
  value = kind_cluster.cluster.???
}
