resource "azurerm_public_ip" "myterraformpublicip" {
    name                         = "myPublicIP${count.index}"
    location                     = var.location
    resource_group_name          = var.rgname
    allocation_method            = "Dynamic"
   
    tags = {
        environment = var.environment
    }
    count=var.count_num
}


resource "azurerm_network_interface" "myterraformnic" {
    name                      = "myNIC${count.index}"
    location                  = var.location
    resource_group_name       = var.rgname

    ip_configuration {
        name                          = "myNicConfiguration${count.index}"
        subnet_id                     = var.subnet_id
        private_ip_address_allocation = "static"
        private_ip_address            = element(var.ip_addresses, count.index)
        public_ip_address_id          = "${length(azurerm_public_ip.myterraformpublicip.*.id) > 0 ? element(concat(azurerm_public_ip.myterraformpublicip.*.id, list("")), count.index) : ""}"
      }
    
        depends_on =[azurerm_public_ip.myterraformpublicip]

        tags = {
            environment = var.environment
        }
        
        count=var.count_num

}

resource "azurerm_network_interface_security_group_association" "example" {
    network_interface_id      = azurerm_network_interface.myterraformnic[count.index].id
    network_security_group_id = var.network_security_group_id
    count=var.count_num
}


resource "random_id" "randomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group = var.rgname
    }
    
    byte_length = 8
}

resource "azurerm_storage_account" "mystorageaccount" {
    name                        = "${random_id.randomId.hex}${count.index}"
    resource_group_name         = var.rgname
    location                    = var.location
    account_tier                = "Standard"
    account_replication_type    = "LRS"
    count= var.count_num
    tags = {
        environment = var.environment
    }
}

resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits = 4096
}
output "tls_private_key" { value = "${tls_private_key.example_ssh.private_key_pem}" }



# Create virtual machine
resource "azurerm_linux_virtual_machine" "myterraformvm" {
    name                  = "myVM${count.index}"
    location              = var.location
    resource_group_name   = var.rgname
    count= var.count_num
    network_interface_ids =  [azurerm_network_interface.myterraformnic[count.index].id]
    size                  = var.vm_size
    availability_set_id   = var.avl_set_id
    os_disk {
        name              = "myOsDisk${count.index}"
        caching           = "ReadWrite"
        storage_account_type = "Premium_LRS"
    }
    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04.0-LTS"
        version   = "latest"
    }

    computer_name  = "myvm${count.index}"
    admin_username = "redhat"
    disable_password_authentication = true
    
   admin_ssh_key {
        username       = "redhat"
        public_key     = tls_private_key.example_ssh.public_key_openssh
    }

    boot_diagnostics {
       
        storage_account_uri = azurerm_storage_account.mystorageaccount[count.index].primary_blob_endpoint
    }

   
    tags = {
        environment = var.environment
    }
}


resource "null_resource" "configuration" {
  connection {
        host = element(azurerm_public_ip.myterraformpublicip.*.ip_address, count.index) 
        user = "redhat"
        type = "ssh"
        private_key = tls_private_key.example_ssh.private_key_pem
        timeout = "2m"
        agent = false
        
    }

     provisioner "remote-exec" {
        inline = [
          "sudo apt-get update",
          "sudo wget -O drupal-9.0.0.zip https://ftp.drupal.org/files/projects/drupal-9.0.0.zip",
          "sudo apt-get install unzip -y",
          "sudo apt-get install php libapache2-mod-php php-mcrypt php-mysql php-xml -y",
          "sudo apt-get install apache2 -y",
          "sudo unzip  drupal-9.0.0.zip -d /var/www/html",

        ]
    }
     depends_on = [azurerm_linux_virtual_machine.myterraformvm,azurerm_public_ip.myterraformpublicip]

    count=var.count_num
}

resource "azurerm_network_interface_backend_address_pool_association" "example" {
  /*depends_on  = [null_resource.configuration]*/
  network_interface_id    = element(azurerm_network_interface.myterraformnic.*.id, count.index)
  ip_configuration_name   = "myNicConfiguration${count.index}"
  backend_address_pool_id = var.bapid
  count= var.count_num
}