resource "kubernetes_namespace" "ingress_nginx" {
  metadata {
    name = "ingress-nginx"
  }
}

resource "helm_release" "ingress_nginx" {
  name       = "ingress-nginx"
  namespace  = kubernetes_namespace.ingress_nginx.metadata[0].name
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.11.3"

  set = [
    {
      name  = "controller.service.type"
      value = "LoadBalancer"
    },
    {
      name  = "controller.replicaCount"
      value = "2"
    },
    {
      name  = "controller.metrics.enabled"
      value = "true"
    },
    {
      name  = "controller.admissionWebhooks.enabled"
      value = "true"
    },
  ]

  depends_on = [
    azurerm_kubernetes_cluster.main,
  ]
}