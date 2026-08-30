provider "kubernetes" {
  host                   = module.kubernetes.kubeconfig_data.server
  cluster_ca_certificate = module.kubernetes.kubeconfig_data.ca
  client_certificate     = module.kubernetes.kubeconfig_data.cert
  client_key             = module.kubernetes.kubeconfig_data.key
}

provider "flux" {
  kubernetes = {
    host                   = module.kubernetes.kubeconfig_data.server
    cluster_ca_certificate = module.kubernetes.kubeconfig_data.ca
    client_certificate     = module.kubernetes.kubeconfig_data.cert
    client_key             = module.kubernetes.kubeconfig_data.key
  }

  git = {
    url = "ssh://git@github.com/${var.github_owner}/${var.repository_name}.git"
    ssh = {
      username    = "git"
      private_key = file(abspath("${path.module}/${var.flux_ssh_private_key_path}"))
    }
  }
}