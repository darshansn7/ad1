
variable "vm_rg" {
  type = string
}

variable "rg_location" {
  type = string
}
variable "vnet_name" {
  type = string
}

variable "subnet_name" {
  type = string
}

variable "network_security_group_name" {
  type = string
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