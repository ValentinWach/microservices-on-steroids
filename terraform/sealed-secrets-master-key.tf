resource "kubernetes_secret_v1" "sealed_secrets_master_key" {
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
