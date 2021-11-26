variable "vm_rg" {
  type = string
}

variable "rg_location" {
  type = string
}

variable "recovery_services_vault_name" {
  type = string
}

variable "recovery_services_vault_sku" {
  type = string
}


variable "soft_delete_enabled" {
  type = string
}


variable "vm_backup_policy_name" {
  type = string
}

variable "time_zone" {
  type = string
}


variable "instant_restore_retention_days" {
  type = string
}
variable "backup_frequency" {
  type = string
}


variable "backup_time" {
  type = string
}
variable "retention_daily_count" {
  type = string
}
