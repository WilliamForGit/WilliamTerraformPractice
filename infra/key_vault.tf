data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "main" {
  name                          = "kv-${var.project_name}-${var.environment}-${random_string.kv_suffix.result}"
  location                      = azurerm_resource_group.platform.location
  resource_group_name           = azurerm_resource_group.platform.name
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  sku_name                      = "standard"
  rbac_authorization_enabled    = true
  purge_protection_enabled      = false
  soft_delete_retention_days    = 7
  public_network_access_enabled = true

  tags = var.common_tags
}

resource "random_string" "kv_suffix" {
  length  = 4
  special = false
  upper   = false
  numeric = true
}

# Give the Service Principal (Terraform itself) permission to manage secrets,
# so it can create secret resources in subsequent steps
resource "azurerm_role_assignment" "kv_admin_for_sp" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}

# Give AKS kubelet permission to read secrets (used later via CSI driver)
resource "azurerm_role_assignment" "kv_secrets_user_for_aks" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
}