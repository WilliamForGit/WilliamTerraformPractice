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
    # Tell Azure LB to use TCP probes (not HTTP) to check node health.
    # HTTP probes default to GET / which NGINX returns 404 on, causing the
    # probe to fail and the LB to mark nodes unhealthy.
    {
      name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-health-probe-protocol"
      value = "tcp"
    },
    # Keep externalTrafficPolicy at Cluster (which is the default) — this means
    # traffic is distributed across all nodes regardless of which has the pod.
    {
      name  = "controller.service.externalTrafficPolicy"
      value = "Cluster"
    },
  ]

  depends_on = [
    azurerm_kubernetes_cluster.main,
  ]
}