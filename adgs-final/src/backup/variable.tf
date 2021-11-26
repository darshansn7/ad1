variable "vm_rg" {
  type        = string
  description = "virtual machine resource group name"
}

variable "rg_location" {
  type        = string
  description = "resource group location"
}

#service vault
variable "recovery_services_vault_name" {
  type        = string
  description = "recovery service vault name"
}

variable "recovery_services_vault_sku" {
  type        = string
  description = "recovery service vault sku"
}

variable "soft_delete_enabled" {
  type        = bool
  description = "is soft delete enabled or not"
}

#backup policy
variable "vm_backup_policy_name" {
  type        = string
  description = "vm backup policy name"
}

variable "time_zone" {
  type        = string
  description = "time zone default to UTC"
}

variable "instant_restore_retention_days" {
  type        = string
  description = "instant restore retention range in days"
}

variable "backup_frequency" {
  type        = string
  description = "backup frequency Must be either Daily or Weekly"
}

variable "backup_time" {
  type        = string
  description = "time of day to perform the backup in 24hour format."
}

variable "retention_daily_count" {
  type        = string
  description = "The number of daily backups to keep. Must be between 7 and 9999."
}

variable "virtual_machine_id" {
  type        = string
  description = "virtual machine id"
}