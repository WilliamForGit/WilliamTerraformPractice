output "resource_group_name" {
  description = "Name of the platform resource group"
  value       = azurerm_resource_group.platform.name
}

output "log_analytics_workspace_id" {
  description = "Resource ID of the Log Analytics workspace (used by AKS later)"
  value       = azurerm_log_analytics_workspace.main.id
}

output "application_insights_connection_string" {
  description = "Connection string for App Insights (used by .NET services later)"
  value       = azurerm_application_insights.main.connection_string
  sensitive   = true
}

output "acr_login_server" {
  description = "ACR endpoint for docker login and image references"
  value       = azurerm_container_registry.main.login_server
}

output "aks_cluster_name" {
  description = "AKS cluster name (used for az aks get-credentials)"
  value       = azurerm_kubernetes_cluster.main.name
}

output "aks_node_resource_group" {
  description = "Auto-created RG containing AKS infrastructure (VMs, disks, LBs)"
  value       = azurerm_kubernetes_cluster.main.node_resource_group
}

output "key_vault_name" {
  description = "Key Vault name for CSI driver references"
  value       = azurerm_key_vault.main.name
}

output "key_vault_uri" {
  description = "Key Vault URI for application config"
  value       = azurerm_key_vault.main.vault_uri
}

output "postgres_fqdn" {
  description = "PostgreSQL fully-qualified hostname"
  value       = azurerm_postgresql_flexible_server.main.fqdn
}

output "servicebus_namespace_endpoint" {
  description = "Service Bus namespace endpoint for SDK config"
  value       = azurerm_servicebus_namespace.main.endpoint
}

output "ingress_namespace" {
  description = "Namespace where NGINX ingress controller runs"
  value       = kubernetes_namespace.ingress_nginx.metadata[0].name
}

output "cert_manager_namespace" {
  description = "Namespace where cert-manager runs"
  value       = kubernetes_namespace.cert_manager.metadata[0].name
}

output "kubectl_get_ingress_ip_command" {
  description = "Command to get the public IP of the ingress controller"
  value       = "kubectl get svc -n ${kubernetes_namespace.ingress_nginx.metadata[0].name} ingress-nginx-controller -o jsonpath='{.status.loadBalancer.ingress[0].ip}'"
}

output "ingress_static_ip" {
  description = "Static public IP for NGINX Ingress (use this for DNS A records)"
  value       = azurerm_public_ip.ingress.ip_address
}