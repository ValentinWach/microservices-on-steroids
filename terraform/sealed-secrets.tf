resource "kubernetes_secret_v1" "sealed-secrets-master-key" {
  depends_on = [module.kubernetes]

  metadata {
    name      = "sealed-secrets-key"
    namespace = "kube-system"
    labels = {
      "sealedsecrets.bitnami.com/sealed-secrets-key" = "active"
    }
  }

  type = "kubernetes.io/tls"
  data = {
    "tls.crt" = file(abspath("${path.module}/${var.sealed_secrets_cert_path}"))
    "tls.key" = file(abspath("${path.module}/${var.sealed_secrets_key_path}"))
  }
}

resource "helm_release" "sealed-secrets" {
  depends_on = [kubernetes_secret_v1.sealed-secrets-master-key]
  chart      = "sealed-secrets"
  name       = "sealed-secrets"
  namespace  = "sealed-secrets"
  repository = "https://bitnami.github.io/sealed-secrets"
  create_namespace = true
}