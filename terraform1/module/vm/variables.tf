variable "rgname" { }
variable "location" { }
variable "environment" {}
variable "subnet_id" { }
variable "ip_addresses" {
  default = [
    "192.168.0.50",
    "192.168.0.51",
  ]
}
variable "network_security_group_id"{}
variable "vm_size"  {} 
variable "avl_set_id" { }
variable "count_num" { }
variable "bapid" { }


 
