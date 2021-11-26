################################################
#    GENERAL PREFIX VARIABLES
################################################

variable "client_name" {
  description = "Client Short Name"
  type        = string
  default     = "adgs"
}

variable "location" {
  description = "Location"
  type        = string
  default     = "us"
}

variable "project_name" {
  description = "Project short name"
  type        = string
  default     = "vm"
}

variable "environment" {
  description = "Environment short name"
  type        = string
  default     = "d"
}

variable "cloud_type" {
  description = "Cloud provider"
  type        = string
  default     = "a"
}


################################################
#    GENERAL TAGS VARIABLES
################################################

variable "sub_request_id" {
  type    = string
  default = "201"
}

variable "product_type" {
  type    = string
  default = "Solutions.AI"
}

variable "solution_name" {
  type    = string
  default = "IRG"
}

variable "enagagement_name" {
  type    = string
  default = "Data and Analytics"
}

variable "sensitivity" {
  type    = string
  default = "Non-Sensitive"
}

variable "provisioned_by" {
  type    = string
  default = "System Generated"
}

variable "service_group" {
  type    = string
  default = "Development Hub Services"
}

variable "service_name" {
  type    = string
  default = "Data Pipeline"
}

variable "purpose" {
  type    = string
  default = "AIP"
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
  default = [{
    name                       = "zookeeper"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "2181"
    source_address_prefix      = "*"
    destination_address_prefix = "*"

  },
  {
    name                       = "elasticsearch"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "9200"
    source_address_prefix      = "*"
    destination_address_prefix = "*"

  },
  {
    name                       = "aspire"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "50505"
    source_address_prefix      = "*"
    destination_address_prefix = "*"

  }]
}

variable "managed_disk_config" {
  type = set(object(
    {
      name                 = string
      storage_account_type = string
      disk_size_gb         = number
      lun                  = string
      caching              = string

    }
  ))
  default = [
    {
      name                 = "di1"
      storage_account_type = "Standard_LRS"
      disk_size_gb         = 10
      lun                  = "10"
      caching              = "ReadWrite"
  }]
}

variable "client_id" {
  type    = string
  default = "a576a286-8650-4364-aa9e-798e7fc923a2"
}

variable "tenant_id" {
  type    = string
  default = "681562d3-f4f8-4277-a0a5-a960ed5b12eb"
}

variable "client_secret" {
  type    = string
  default = "vJz7Q~pzeBlXnm2-zmuCIzkQc~Y-vdeCpyRa0"
}

variable "subscription_id" {
  type    = string
  default = "ed8fd191-c919-4c7f-8760-175cdb464f79"
}