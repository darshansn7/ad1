resource "random_integer" "int_suffix" {
  min = 100
  max = 999
  keepers = {
    # Generate a new id each time we change any of the prefix varibles
    base_name_prefix = local.base_name_prefix
  }
}


locals {
  // based on JobAid naming convention
  base_name_prefix = "${local.client_name_short}${local.location_short}${local.project_name_short}${local.environment_short}${local.cloud_type_short}"
  base_name_suffix = random_integer.int_suffix.result


  # Shorten and lowercase input parameters from UI
  client_name_short  = substr(lower(var.client_name), 0, 3)
  location_short     = substr(lower(var.location), 0, 2)
  project_name_short = substr(lower(var.project_name), 0, 2)
  environment_short  = substr(lower(var.environment), 0, 1)
  cloud_type_short   = substr(lower(var.cloud_type), 0, 1)

  vm1_nic_name                = "${local.base_name_prefix}nic1${local.base_name_suffix}"
  vm1_key_name                = "${local.base_name_prefix}key1${local.base_name_suffix}"
  vm1_keyvault_vm_secret      = "${local.base_name_prefix}secret1${local.base_name_suffix}"
  virtual_machine1_name       = "${local.base_name_prefix}vm1${local.base_name_suffix}"
  network_security_group_name = "${local.base_name_prefix}nsg${local.base_name_suffix}"

  vm2_nic_name           = "${local.base_name_prefix}nic2${local.base_name_suffix}"
  vm2_key_name           = "${local.base_name_prefix}key2${local.base_name_suffix}"
  vm2_keyvault_vm_secret = "${local.base_name_prefix}secret2${local.base_name_suffix}"
  virtual_machine2_name  = "${local.base_name_prefix}vm2${local.base_name_suffix}"

  vm3_nic_name           = "${local.base_name_prefix}nic3${local.base_name_suffix}"
  vm3_key_name           = "${local.base_name_prefix}key3${local.base_name_suffix}"
  vm3_keyvault_vm_secret = "${local.base_name_prefix}secret3${local.base_name_suffix}"
  virtual_machine3_name  = "${local.base_name_prefix}vm3${local.base_name_suffix}"

  vm4_nic_name           = "${local.base_name_prefix}nic4${local.base_name_suffix}"
  vm4_key_name           = "${local.base_name_prefix}key4${local.base_name_suffix}"
  vm4_keyvault_vm_secret = "${local.base_name_prefix}secret4${local.base_name_suffix}"
  virtual_machine4_name  = "${local.base_name_prefix}vm4${local.base_name_suffix}"

  recovery_services_vault_name = "${local.base_name_prefix}sv${local.base_name_suffix}"
  vm_backup_policy_name        = "${local.base_name_prefix}vmbp${local.base_name_suffix}"

  common_tags = {
    "key" = "value"
  }

}