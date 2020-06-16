
resource "azurerm_availability_set" "example" {
  name                = "example-aset"
  location            = var.location
  resource_group_name = var.rgname
  
  tags = {
        environment = var.environment
    }
    
}


resource "azurerm_public_ip" "lbpublicip" {
  name                = "PublicIPForLB"
  location            = var.location
  resource_group_name = var.rgname
  allocation_method   = "Static"
  
}

resource "azurerm_lb" "azurelb" {
  name                = var.loadbalancer_name
  location            = var.location
  resource_group_name = var.rgname

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lbpublicip.id
  }
}

resource "azurerm_lb_backend_address_pool" "bpepool" {
  resource_group_name =  var.rgname
  loadbalancer_id     = azurerm_lb.azurelb.id
  name                = "BackEndAddressPool"
}

resource "azurerm_lb_probe" "example" {
  resource_group_name = var.rgname
  loadbalancer_id     = azurerm_lb.azurelb.id
  name                = "ssh-running-probe"
  port                = 80
}

resource "azurerm_lb_rule" "example" {
  resource_group_name            = var.rgname
  loadbalancer_id                = azurerm_lb.azurelb.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_id = azurerm_lb_backend_address_pool.bpepool.id
  probe_id = azurerm_lb_probe.example.id

}






