resource "azurerm_resource_group" "platform" {
  name     = "rg-${var.project_name}-${var.environment}"
  location = var.location
  tags     = var.common_tags
}