resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
  }
}

resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  namespace  = kubernetes_namespace.cert_manager.metadata[0].name
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.16.2"

  set = [
    {
      name  = "installCRDs"
      value = "true"
    },
    {
      name  = "prometheus.enabled"
      value = "true"
    },
  ]

  depends_on = [
    azurerm_kubernetes_cluster.main,
  ]
}