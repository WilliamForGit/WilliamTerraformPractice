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

  values = [
    yamlencode({
      controller = {
        replicaCount = 2
        service = {
          type                  = "LoadBalancer"
          externalTrafficPolicy = "Local"
          annotations = {
            # Tell Azure LB which path to use for HTTP health probes.
            # NGINX serves /healthz on every controller pod and returns 200 OK.
            # Combined with externalTrafficPolicy: Local, this makes probes pass.
            "service.beta.kubernetes.io/azure-load-balancer-health-probe-request-path" = "/healthz"
          }
        }
        metrics = {
          enabled = true
        }
        admissionWebhooks = {
          enabled = true
        }
      }
    })
  ]

  depends_on = [
    azurerm_kubernetes_cluster.main,
  ]
}