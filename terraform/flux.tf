resource "flux_bootstrap_git" "flux" {
  depends_on = [
    module.kubernetes,
    helm_release.sealed-secrets,
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

  delete_git_manifests = false
}