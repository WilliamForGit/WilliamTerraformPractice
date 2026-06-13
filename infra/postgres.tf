resource "azurerm_postgresql_flexible_server" "main" {
  name                = "psql-${var.project_name}-${var.environment}-${random_string.psql_suffix.result}"
  resource_group_name = azurerm_resource_group.platform.name
  location            = azurerm_resource_group.platform.location

  version                = "16"
  administrator_login    = "psqladmin"
  administrator_password = var.postgres_admin_password

  sku_name     = "B_Standard_B1ms"
  storage_mb   = 32768
  storage_tier = "P4"

  backup_retention_days        = 7
  geo_redundant_backup_enabled = false

  public_network_access_enabled = true

  tags = var.common_tags

  lifecycle {
    ignore_changes = [
      zone,
      high_availability[0].standby_availability_zone,
    ]
  }
}

resource "random_string" "psql_suffix" {
  length  = 4
  special = false
  upper   = false
  numeric = true
}

# Allow AKS pods to reach PostgreSQL (open to Azure services)
resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_azure" {
  name             = "allow-azure-services"
  server_id        = azurerm_postgresql_flexible_server.main.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

# Store the connection string in Key Vault for apps to retrieve later
resource "azurerm_key_vault_secret" "postgres_connection_string" {
  name         = "postgres-connection-string"
  value        = "Host=${azurerm_postgresql_flexible_server.main.fqdn};Database=postgres;Username=psqladmin;Password=${var.postgres_admin_password};SslMode=Require"
  key_vault_id = azurerm_key_vault.main.id

  depends_on = [azurerm_role_assignment.kv_admin_for_sp]
}