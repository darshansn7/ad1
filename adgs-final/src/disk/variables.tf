variable "virtual_machine_name" {
  type        = string
  description = "virtual machine name"
}

variable "vm_rg" {
  type        = string
  description = "virtual machine resource group"
}

variable "rg_location" {
  type        = string
  description = "resource group location"
}

variable "virtual_machine_id" {
  type        = string
  description = "virtual machine id"
}

variable "common_tags" {
  type        = map(string)
  description = "A map of common tags to be assigned to resources."
}

variable "managed_disk_config" {
  description = "disk configuration details"
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