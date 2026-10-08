resource "kubernetes_namespace_v1" "flux_system" {
  depends_on = [module.kubernetes]

  metadata {
    name = "flux-system"
  }
}

resource "kubernetes_secret_v1" "flux_system" {
  depends_on = [kubernetes_namespace_v1.flux_system]

  metadata {
    name      = "flux-system"
    namespace = kubernetes_namespace_v1.flux_system.metadata[0].name
  }

  type = "Opaque"
  data = {
    identity    = file(abspath("${path.module}/${var.flux_ssh_private_key_path}"))
    known_hosts = var.flux_known_hosts
  }
}

resource "helm_release" "flux_operator" {
  depends_on = [
    module.kubernetes,
    helm_release.sealed-secrets,
    kubernetes_namespace_v1.flux_system,
  ]

  name       = "flux-operator"
  namespace  = kubernetes_namespace_v1.flux_system.metadata[0].name
  chart      = "oci://ghcr.io/controlplaneio-fluxcd/charts/flux-operator"
  version    = var.flux_operator_chart_version

  create_namespace = false
  wait             = true
}

resource "helm_release" "flux_instance" {
  depends_on = [
    helm_release.flux_operator,
    kubernetes_secret_v1.flux_system,
  ]

  name       = "flux"
  namespace  = kubernetes_namespace_v1.flux_system.metadata[0].name
  chart      = "oci://ghcr.io/controlplaneio-fluxcd/charts/flux-instance"
  version    = var.flux_operator_chart_version

  create_namespace = false
  wait             = true

  values = [
    yamlencode({
      instance = {
        distribution = {
          version  = var.flux_version
          registry = "ghcr.io/fluxcd"
        }
        components = [
          "source-controller",
          "kustomize-controller",
          "helm-controller",
          "notification-controller",
        ]
        cluster = {
          type   = "kubernetes"
          domain = "cluster.local"
        }
        sync = {
          kind       = "GitRepository"
          url        = "ssh://git@github.com/${var.github_owner}/${var.repository_name}.git"
          ref        = "refs/heads/main"
          path       = "kubernetes-manifests"
          pullSecret = "flux-system"
        }
      }
    })
  ]
}
