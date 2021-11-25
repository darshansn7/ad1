
variable "virtual_machine_name" {
  type = string
}

variable "vm_rg" {
  type = string
}

variable "rg_location" {
  type = string
}

variable "virtual_machine_id" {
  type = string
}

variable "common_tags" {
  type        = map(string)
  description = "A map of common tags to be assigned to resources."
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