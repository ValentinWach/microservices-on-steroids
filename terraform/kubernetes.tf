module "kubernetes" {
  source  = "hcloud-k8s/kubernetes/hcloud"
  version = "5.0.0"

  cluster_name = var.cluster_name
  hcloud_token = var.hcloud_token

  cluster_kubeconfig_path  = abspath("${path.module}/${var.cluster_kubeconfig_path}")
  cluster_talosconfig_path = abspath("${path.module}/${var.cluster_talosconfig_path}")

  cert_manager_enabled                      = true
  cilium_gateway_api_enabled                = true
  cilium_gateway_api_proxy_protocol_enabled = false

  cluster_delete_protection  = false

  control_plane_nodepools = [
    { name = "control", type = "cx23", location = "fsn1", count = 1 }
  ]
  worker_nodepools = [
    { name = "worker", type = "cx23", location = "fsn1", count = 1 }
  ]
}