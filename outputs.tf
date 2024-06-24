output "kubeconfig_path" {
  value = module.k8_cluster.kubeconfig_path
}

output "kubeconfig_context" {
  value = module.k8_cluster.kubeconfig_context
}