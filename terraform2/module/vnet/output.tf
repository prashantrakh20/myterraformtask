output "vnname" {
  value = azurerm_virtual_network.myterraformnetwork.name
}

output "subname01" {
  value = azurerm_subnet.myterraformsubnet.id

 }

output "net_sec_id" {
  value = azurerm_network_security_group.aznwsg.id
}