resource "azurerm_monitor_action_group" "example" {
  name                = "CriticalAlertsAction"
  resource_group_name = var.rgname
  short_name          = "p0action"

email_receiver {
    name          = "sendtoadmin"
    email_address = "admin@contoso.com"
  }

}

