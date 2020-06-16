variable "rgname" { 
    default = "myres002"

}


variable "count_num" { 
    type = number
    default = 2

}


variable "location" { 
    type = string
    default = "West US 2"
}

variable "environment" {
    type = string
    default = "dev"
}

variable "vn_address_space" {
    default= "192.168.0.0/24"
 }



variable "subnet_address_cidr" { 
    default= "192.168.0.0/24"
   
}
variable "nsgp_name" { 
    default = "mynsg"
}


variable "loadbalancer_name" {
    default = "myloadbalancer01"
}

variable "vm_size" {
   default = "Standard_DS1_v2"

}

variable "mysql_server_name" {
  default="mysql-server-test001"
}

variable "mysql_database" {
  default="mydatabase002"
  
}
