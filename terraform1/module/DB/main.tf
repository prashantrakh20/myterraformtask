resource "azurerm_mysql_server" "example" {
  name                = var.mysql_server_name
  location            = var.location
  resource_group_name = var.rgname

  sku_name = "GP_Gen5_2"

  storage_profile {
    storage_mb            = 5120
    backup_retention_days = 7
    geo_redundant_backup  = "Disabled"
  }

  administrator_login          = "psqladminun"
  administrator_login_password = "H@Sh1CoR3!"
  version                      = "5.7"
  ssl_enforcement              = "Enabled"
  
}

resource "azurerm_mysql_configuration" "example" {
  name                = "interactive_timeout"
  resource_group_name = var.rgname
  server_name         = azurerm_mysql_server.example.name
  value               = "600"
}

resource "azurerm_mysql_database" "example" {
  name                = var.mysql_database
  resource_group_name = var.rgname
  server_name         = azurerm_mysql_server.example.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

resource "azurerm_mysql_firewall_rule" "example" {
  name                = "firewallsetting"
  resource_group_name = var.rgname
  server_name         = azurerm_mysql_server.example.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "255.255.255.255"
}