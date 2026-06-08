resource "azurerm_container_registry" "main" {
  name                = "acr${var.project_name}${var.environment}${random_string.acr_suffix.result}"
  resource_group_name = azurerm_resource_group.platform.name
  location            = azurerm_resource_group.platform.location
  sku                 = "Basic"
  admin_enabled       = false
  tags                = var.common_tags
}

resource "random_string" "acr_suffix" {
  length  = 6
  special = false
  upper   = false
  numeric = true
}