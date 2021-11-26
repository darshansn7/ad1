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
  subnet_name = "aianoaddazays01"

  #nic
  nic_name                          = local.vm1_nic_name
  nic_config_name                   = "vm_internal"
  nic_private_ip_address_allocation = "Dynamic"

  #vm
  virtual_machine_name            = local.vm1_virtual_machine_name
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

  managed_disk_required = true
  managed_disk_config   = var.managed_disk_config

  network_security_group_required = true
  network_security_group_name     = local.network_security_group_name
  security_rule                   = var.security_rule


  #ansible
  ansible_required        = true
  vm_packages             = ["jdk-11.0.12_linux-x64_bin.rpm", "apache-zookeeper-3.5.6-bin.tar.gz"]
  playbooks               = ["java.yml", "zk-install.yml"]
  zookeeper_host_name     = ""
  elasticsearch_host_name = ""
  client_id               = var.client_id
  client_secret           = var.client_secret
  tenant_id               = var.tenant_id
  subscription_id         = var.subscription_id
  storage_account_name    = "adgsvmpackages"
  container_name          = "packages"
  custom_data             = filebase64("${path.module}/eg.sh")
  common_tags             = local.common_tags

  #vm backup
  vm_backup_required           = false
  recovery_services_vault_name = local.vm1_recovery_services_vault_name
  recovery_services_vault_sku  = "Standard"
  vm_backup_policy_name        = local.vm1_vm_backup_policy_name
  # policy
  time_zone                      = "UTC"
  instant_restore_retention_days = 2
  backup_frequency               = "Daily"
  backup_time                    = "06:30"
  retention_daily_count          = 10
  soft_delete_enabled            = true
}

module "vm2" {
  source = "./../src"

  #
  vm_rg       = "aianoaddarrsg01"
  rg_location = "eastus2"
  vnet_name   = "aianoaddapvpc01"
  subnet_name = "aianoaddazays01"

  #nic
  nic_name                          = local.vm2_nic_name
  nic_config_name                   = "vm_internal"
  nic_private_ip_address_allocation = "Dynamic"

  #vm
  virtual_machine_name            = local.vm2_virtual_machine_name
  vm_size                         = "Standard_D4s_v3"
  vm_source_image_id              = ""
  vm_source_image_publisher       = "OpenLogic"
  vm_source_image_offer           = "CentOS"
  vm_source_image_sku             = "7.4"
  vm_source_image_version         = "latest"
  vm_os_disk_name                 = "osdisk"
  vm_os_disk_caching              = "ReadWrite"
  vm_os_disk_storage_account_type = "Standard_LRS"
  vm_computer_name                = "aipuser2"
  vm_admin_username               = "aipuser2"


  #ansible
  ansible_required        = true
  vm_packages             = ["jdk-11.0.12_linux-x64_bin.rpm", "elasticsearch-7.2.1-x86_64.rpm", "Saga_Server.zip"]
  playbooks               = ["java.yml", "elastic-install.yml", "saga-install.yml"]
  zookeeper_host_name     = module.vm1.virtual_machine_admin_username
  elasticsearch_host_name = ""
  client_id               = var.client_id
  client_secret           = var.client_secret
  tenant_id               = var.tenant_id
  subscription_id         = var.subscription_id
  storage_account_name    = "adgsvmpackages"
  container_name          = "packages"
  custom_data             = filebase64("${path.module}/eg.sh")
  common_tags             = local.common_tags

  #vm backup
  vm_backup_required           = false
  recovery_services_vault_name = local.vm2_recovery_services_vault_name
  recovery_services_vault_sku  = "Standard"
  vm_backup_policy_name        = local.vm2_vm_backup_policy_name
  # policy
  time_zone                      = "UTC"
  instant_restore_retention_days = 2
  backup_frequency               = "Daily"
  backup_time                    = "06:30"
  retention_daily_count          = 10
  soft_delete_enabled            = true
  depends_on                     = [module.vm1]
}

module "vm3" {
  source = "./../src"

  #
  vm_rg       = "aianoaddarrsg01"
  rg_location = "eastus2"
  vnet_name   = "aianoaddapvpc01"
  subnet_name = "aianoaddazays01"

  #nic
  nic_name                          = local.vm3_nic_name
  nic_config_name                   = "vm_internal"
  nic_private_ip_address_allocation = "Dynamic"

  #vm
  virtual_machine_name            = local.vm3_virtual_machine_name
  vm_size                         = "Standard_D4s_v3"
  vm_source_image_id              = ""
  vm_source_image_publisher       = "OpenLogic"
  vm_source_image_offer           = "CentOS"
  vm_source_image_sku             = "7.4"
  vm_source_image_version         = "latest"
  vm_os_disk_name                 = "osdisk"
  vm_os_disk_caching              = "ReadWrite"
  vm_os_disk_storage_account_type = "Standard_LRS"
  vm_computer_name                = "aipuser3"
  vm_admin_username               = "aipuser3"


  #ansible
  ansible_required        = true
  vm_packages             = ["jdk-11.0.12_linux-x64_bin.rpm", "python-lxml-3.2.1-4.el7.x86_64.rpm", "aspire-4.0-SNAPSHOT.tar.gz"]
  playbooks               = ["java.yml", "aspire-master-install.yml"]
  zookeeper_host_name     = module.vm1.virtual_machine_admin_username
  elasticsearch_host_name = module.vm2.virtual_machine_admin_username
  client_id               = var.client_id
  client_secret           = var.client_secret
  tenant_id               = var.tenant_id
  subscription_id         = var.subscription_id
  storage_account_name    = "adgsvmpackages"
  container_name          = "packages"
  custom_data             = filebase64("${path.module}/eg.sh")
  common_tags             = local.common_tags

  #vm backup
  vm_backup_required           = false
  recovery_services_vault_name = local.vm3_recovery_services_vault_name
  recovery_services_vault_sku  = "Standard"
  vm_backup_policy_name        = local.vm3_vm_backup_policy_name
  # policy
  time_zone                      = "UTC"
  instant_restore_retention_days = 2
  backup_frequency               = "Daily"
  backup_time                    = "06:30"
  retention_daily_count          = 10
  soft_delete_enabled            = true
  depends_on                     = [module.vm2]
}

module "vm4" {
  source = "./../src"

  #
  vm_rg       = "aianoaddarrsg01"
  rg_location = "eastus2"
  vnet_name   = "aianoaddapvpc01"
  subnet_name = "aianoaddazays01"

  #nic
  nic_name                          = local.vm4_nic_name
  nic_config_name                   = "vm_internal"
  nic_private_ip_address_allocation = "Dynamic"

  #vm
  virtual_machine_name            = local.vm4_virtual_machine_name
  vm_size                         = "Standard_D4s_v3"
  vm_source_image_id              = ""
  vm_source_image_publisher       = "OpenLogic"
  vm_source_image_offer           = "CentOS"
  vm_source_image_sku             = "7.4"
  vm_source_image_version         = "latest"
  vm_os_disk_name                 = "osdisk"
  vm_os_disk_caching              = "ReadWrite"
  vm_os_disk_storage_account_type = "Standard_LRS"
  vm_computer_name                = "aipuser4"
  vm_admin_username               = "aipuser4"


  #ansible
  ansible_required        = true
  vm_packages             = ["jdk-11.0.12_linux-x64_bin.rpm", "python-lxml-3.2.1-4.el7.x86_64.rpm", "aspire-4.0-SNAPSHOT.tar.gz"]
  playbooks               = ["java.yml", "aspire-worker-install.yml"]
  zookeeper_host_name     = module.vm1.virtual_machine_admin_username
  elasticsearch_host_name = module.vm2.virtual_machine_admin_username
  client_id               = var.client_id
  client_secret           = var.client_secret
  tenant_id               = var.tenant_id
  subscription_id         = var.subscription_id
  storage_account_name    = "adgsvmpackages"
  container_name          = "packages"
  custom_data             = filebase64("${path.module}/eg.sh")
  common_tags             = local.common_tags

  #vm backup
  vm_backup_required           = false
  recovery_services_vault_name = local.vm4_recovery_services_vault_name
  recovery_services_vault_sku  = "Standard"
  vm_backup_policy_name        = local.vm4_vm_backup_policy_name
  # policy
  time_zone                      = "UTC"
  instant_restore_retention_days = 2
  backup_frequency               = "Daily"
  backup_time                    = "06:30"
  retention_daily_count          = 10
  soft_delete_enabled            = true
  depends_on                     = [module.vm3]
}

