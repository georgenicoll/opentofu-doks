variable "do_token" {
  type        = string
  description = "The token to use when running commands against the digital ocean API"
  default     = "<needs to be overridden>"
}

locals {
  kubeconfig_path = abspath("${path.root}/kubeconfig")
}

module "k8_cluster" {
  source   = "./digital_ocean_cluster"
  do_token = var.do_token
}

# module "k8_cluster" {
#   source   = "./kind_cluster"
# }

module "nginx" {
  source                 = "./nginx"
  cluster_endpoint       = module.k8_cluster.cluster_endpoint
  cluster_token          = module.k8_cluster.cluster_token
  cluster_ca_certificate = module.k8_cluster.cluster_ca_certificate
}

resource "local_file" "kubeconfig" {
  content  = module.k8_cluster.raw_kube_config
  filename = local.kubeconfig_path
}
