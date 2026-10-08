variable "hcloud_token" {
  type      = string
  sensitive = true
}

variable "github_owner" {
  description = "GitHub owner (organization or user)"
  type        = string
  default     = "ValentinWach"
}

variable "repository_name" {
  description = "Name of the GitHub repository for Flux"
  type        = string
  default     = "microservices-on-steroids"
}

variable "cluster_name" {
  description = "Name of the Kubernetes cluster"
  type        = string
  default     = "k8s"
}

variable "cluster_kubeconfig_path" {
  description = "Path to the kubeconfig file"
  type        = string
  default     = "../k8s-config.yml"
}

variable "cluster_talosconfig_path" {
  description = "Path to the Talos config file"
  type        = string
  default     = "../talos-config.yml"
}

variable "flux_ssh_private_key_path" {
  description = "Path to the SSH private key for Flux Git access"
  type        = string
  default     = "../.secrets/flux-deploy-key"
}

variable "flux_known_hosts" {
  description = "SSH known_hosts entry for the Flux Git host (GitHub)"
  type        = string
  default     = "github.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg="
}

variable "flux_operator_chart_version" {
  description = "Helm chart version of flux-operator"
  type        = string
  default     = "0.61.0"
}

variable "flux_version" {
  description = "Flux distribution version range managed by FluxInstance"
  type        = string
  default     = "2.8.x"
}

variable "sealed_secrets_cert_path" {
  description = "Path to the Sealed Secrets TLS certificate"
  type        = string
  default     = "../.secrets/sealed-secrets-master.crt"
}

variable "sealed_secrets_key_path" {
  description = "Path to the Sealed Secrets TLS private key"
  type        = string
  default     = "../.secrets/sealed-secrets-master.key"
}
