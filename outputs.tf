output "cluster_name" {
  value = module.k8_cluster.cluster_name
}

output "kubeconfig_path" {
  value = local.kubeconfig_path
}