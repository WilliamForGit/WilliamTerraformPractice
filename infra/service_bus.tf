resource "azurerm_servicebus_namespace" "main" {
  name                = "sb-${var.project_name}-${var.environment}-${random_string.sb_suffix.result}"
  location            = azurerm_resource_group.platform.location
  resource_group_name = azurerm_resource_group.platform.name
  sku                 = "Basic"

  tags = var.common_tags
}

resource "random_string" "sb_suffix" {
  length  = 4
  special = false
  upper   = false
  numeric = true
}

# Two example queues — your microservices will publish/consume from these
resource "azurerm_servicebus_queue" "orders" {
  name         = "orders"
  namespace_id = azurerm_servicebus_namespace.main.id

  max_size_in_megabytes = 1024
  default_message_ttl   = "P14D"  # 14 days
}

resource "azurerm_servicebus_queue" "notifications" {
  name         = "notifications"
  namespace_id = azurerm_servicebus_namespace.main.id

  max_size_in_megabytes = 1024
  default_message_ttl   = "P14D"
}

# Give AKS pods permission to send/receive Service Bus messages
resource "azurerm_role_assignment" "sb_data_owner_for_aks" {
  scope                = azurerm_servicebus_namespace.main.id
  role_definition_name = "Azure Service Bus Data Owner"
  principal_id         = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
}

# Store Service Bus endpoint in Key Vault
resource "azurerm_key_vault_secret" "servicebus_endpoint" {
  name         = "servicebus-namespace"
  value        = azurerm_servicebus_namespace.main.endpoint
  key_vault_id = azurerm_key_vault.main.id

  depends_on = [azurerm_role_assignment.kv_admin_for_sp]
}