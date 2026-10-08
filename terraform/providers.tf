provider "kubernetes" {
  host                   = module.kubernetes.kubeconfig_data.server
  cluster_ca_certificate = module.kubernetes.kubeconfig_data.ca
  client_certificate     = module.kubernetes.kubeconfig_data.cert
  client_key             = module.kubernetes.kubeconfig_data.key
}

provider "helm" {
  kubernetes = {
    host                   = module.kubernetes.kubeconfig_data.server
    cluster_ca_certificate = module.kubernetes.kubeconfig_data.ca
    client_certificate     = module.kubernetes.kubeconfig_data.cert
    client_key             = module.kubernetes.kubeconfig_data.key
  }
}