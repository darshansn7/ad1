variable "vm_rg" {
  type        = string
  description = "virtual machine resource group"
}

variable "rg_location" {
  type        = string
  description = "resource group location"
}
variable "vnet_name" {
  type        = string
  description = "virtual network name"
}

variable "subnet_name" {
  type        = string
  description = "subnet name"
}

variable "network_security_group_name" {
  type        = string
  description = "network security group name"
}


variable "security_rule" {
  description = "security rules for the network security group"
  type = set(object(
    {
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
    }
  ))
  default = []
}