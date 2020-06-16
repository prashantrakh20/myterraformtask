provider "azurerm" {
  version = "~> 2.1.0"
  features {
  }
}

resource "azurerm_resource_group" "myterraformgroup" {
    name     = var.rgname
    location = var.location

    tags = {
        environment = var.environment
    }
}



module "azurerm_virtual_network" {
  source      = "../module/vnet"
  environment = var.environment
  vn_address_space=var.vn_address_space
  rgname= var.rgname
  location=var.location
  subnet_address_cidr = var.subnet_address_cidr
  count_num = var.count_num
  nsgp_name = var.nsgp_name

}


module "loadbalancer" {
  source      = "../module/loadbalancer"
  rgname      = var.rgname
  location    = var.location
  environment = var.environment
  loadbalancer_name = var.loadbalancer_name
  count_num = var.count_num

}



module "virtualmachine" {
  source      = "../module/vm"
  rgname      = var.rgname
  location    = var.location
  environment = var.environment
  subnet_id   = "${module.azurerm_virtual_network.subname01}"
  network_security_group_id= "${module.azurerm_virtual_network.net_sec_id}"
  avl_set_id = "${module.loadbalancer.avlsetid}"
  vm_size = var.vm_size
  count_num = var.count_num
  bapid = "${module.loadbalancer.azlbp}"


}

module "database" {
  source      = "../module/DB"
  rgname = var.rgname
  location = var.location
  environment = var.environment
  mysql_server_name = var.mysql_server_name
  mysql_database = var.mysql_database

}  




