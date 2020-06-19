output "avlsetid" {
    value = azurerm_availability_set.example.id
}

output "azlbp" {
 value= azurerm_lb_backend_address_pool.bpepool.id
}