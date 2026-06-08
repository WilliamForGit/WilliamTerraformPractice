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