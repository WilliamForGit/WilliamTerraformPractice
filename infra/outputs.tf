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