# Static public IP for the NGINX Ingress LoadBalancer.
# Must live in the AKS-managed RG so the kubelet identity has permission to attach it.
resource "azurerm_public_ip" "ingress" {
  name                = "pip-ingress-${var.project_name}-${var.environment}"
  resource_group_name = azurerm_kubernetes_cluster.main.node_resource_group
  location            = azurerm_resource_group.platform.location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = var.common_tags
}