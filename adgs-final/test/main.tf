provider "azurerm" {
  features {}
  tenant_id       = "681562d3-f4f8-4277-a0a5-a960ed5b12eb"
  client_id       = "a576a286-8650-4364-aa9e-798e7fc923a2"
  client_secret   = "vJz7Q~pzeBlXnm2-zmuCIzkQc~Y-vdeCpyRa0"
  subscription_id = "ed8fd191-c919-4c7f-8760-175cdb464f79"
}
module "vm1" {
  source = "./../src"

  #
  vm_rg       = "aianoaddarrsg01"
  rg_location = "eastus2"
  vnet_name   = "aianoaddapvpc01"
  subnet_name = "aianoaddaspvt01"

  #nic
  nic_name                          = local.vm1_nic_name
  nic_config_name                   = "vm_internal"
  nic_private_ip_address_allocation = "Dynamic"

  #key-vault
  vm_key_name        = local.vm1_key_name
  key_vault_name     = "adgsvmdeployment"
  keyvault_vm_secret = local.vm1_keyvault_vm_secret

  #vm
  virtual_machine_name            = local.virtual_machine1_name
  vm_size                         = "Standard_D4s_v3"
  vm_source_image_id              = ""
  vm_source_image_publisher       = "OpenLogic"
  vm_source_image_offer           = "CentOS"
  vm_source_image_sku             = "7.4"
  vm_source_image_version         = "latest"
  vm_os_disk_name                 = "osdisk"
  vm_os_disk_caching              = "ReadWrite"
  vm_os_disk_storage_account_type = "Standard_LRS"
  vm_computer_name                = "aipuser1"
  vm_admin_username               = "aipuser1"

  managed_disk_required           = false
  managed_disk_config             = var.managed_disk_config

  network_security_group_required = false
  network_security_group_name = local.network_security_group_name
  security_rule = var.security_rule


  #ansible
    ansible_required                = true
  vm_packages             = ["jdk-11.0.12_linux-x64_bin.rpm", "apache-zookeeper-3.5.6-bin.tar.gz"]
  playbooks               = ["java.yml", "zk-install.yml"]
  zookeeper_host_name     = ""
  elasticsearch_host_name = ""
  private_key             = ""
  client_id               = var.client_id
  client_secret           = var.client_secret
  tenant_id               = var.tenant_id
  subscription_id         = var.subscription_id
  storage_account_name    = "adgsvmpackages"
  container_name          = "packages"
  custom_data             = filebase64("${path.module}/eg.sh")
  common_tags             = local.common_tags

  #vm backup
  recovery_services_vault_name = local.recovery_services_vault_name
  recovery_services_vault_sku  = "Standard"
  vm_backup_policy_name        = local.vm_backup_policy_name
  # policy
  time_zone                      = "UTC"
  instant_restore_retention_days = 2
  backup_frequency               = "Daily"
  backup_time                    = "06:30"
  retention_daily_count          = 10
  soft_delete_enabled            = true
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

  }]
}