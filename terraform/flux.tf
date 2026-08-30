resource "flux_bootstrap_git" "flux" {
  depends_on = [
    module.kubernetes,
    kubernetes_secret_v1.sealed_secrets_master_key,
  ]
  path = "kubernetes-manifests"

  components = [
    "source-controller",
    "kustomize-controller",
    "helm-controller",
    "notification-controller"
  ]

  namespace = "flux-system"

  version = "v2.8.7"
}