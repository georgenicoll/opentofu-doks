variable "do_token" {
  type        = string
  description = "The token to use when running commands against the digital ocean API"
  default     = "<needs to be overridden>"
}

locals {
  kubeconfig_path = abspath("${path.root}/kubeconfig")
}

# Uncomment the k8 cluster to deploy.. digitalocean or local kind

module "k8_cluster" {
  source          = "./digital_ocean_cluster"
  do_token        = var.do_token
  kubeconfig_path = local.kubeconfig_path
}

# module "k8_cluster" {
#   source   = "./kind_cluster"
#   kubeconfig_path = local.kubeconfig_path
# }

module "nginx" {
  source             = "./nginx"
  kubeconfig_path    = module.k8_cluster.kubeconfig_path
  kubeconfig_context = module.k8_cluster.kubeconfig_context
}
