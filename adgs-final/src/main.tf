resource "azurerm_network_interface" "vm_nic" {
  name                = var.nic_name
  location            = var.rg_location
  resource_group_name = var.vm_rg

  ip_configuration {
    name                          = var.nic_config_name
    subnet_id                     = data.azurerm_subnet.main.id
    private_ip_address_allocation = var.nic_private_ip_address_allocation
  }
}


resource "azurerm_linux_virtual_machine" "linux_vm" {
  name                  = var.virtual_machine_name
  resource_group_name   = var.vm_rg
  location              = var.rg_location
  network_interface_ids = ["${azurerm_network_interface.vm_nic.id}"]
  size                  = var.vm_size

  source_image_reference {
    publisher = var.vm_source_image_publisher
    offer     = var.vm_source_image_offer
    sku       = var.vm_source_image_sku
    version   = var.vm_source_image_version
  }

  os_disk {
    name                 = "${var.virtual_machine_name}-${var.vm_os_disk_name}"
    caching              = var.vm_os_disk_caching
    storage_account_type = var.vm_os_disk_storage_account_type
  }

  admin_ssh_key {
    username   = var.vm_admin_username
    public_key = azurerm_ssh_public_key.main.public_key
  }

  computer_name                   = var.vm_computer_name
  admin_username                  = var.vm_admin_username
  admin_password                  = sensitive(random_password.password.result)
  disable_password_authentication = false
  #custom_data                     = var.custom_data
  tags       = var.common_tags
  depends_on = [module.network_security_group, null_resource.create_key_file, random_password.password, azurerm_ssh_public_key.main]
}

module "network_security_group" {
  source                      = "./nsg"
  count                       = var.network_security_group_required == true ? 1 : 0
  vm_rg                       = var.vm_rg
  rg_location                 = var.rg_location
  vnet_name                   = var.vnet_name
  subnet_name                 = var.subnet_name
  network_security_group_name = var.network_security_group_name
  security_rule               = var.security_rule
}

module "disk" {
  source               = "./disk"
  count                = var.managed_disk_required == true ? 1 : 0
  vm_rg                = var.vm_rg
  rg_location          = var.rg_location
  virtual_machine_name = var.virtual_machine_name
  virtual_machine_id   = azurerm_linux_virtual_machine.linux_vm.id
  managed_disk_config  = var.managed_disk_config
  common_tags          = var.common_tags
  depends_on           = [azurerm_linux_virtual_machine.linux_vm]
}


module "ansible" {
  source                  = "./ansible"
  count                   = var.ansible_required == true ? 1 : 0
  vm_private_ip_address   = azurerm_linux_virtual_machine.linux_vm.private_ip_address
  vm_admin_username       = var.vm_admin_username
  vm_password             = sensitive(random_password.password.result)
  vm_packages             = var.vm_packages
  client_id               = var.client_id
  client_secret           = var.client_secret
  tenant_id               = var.tenant_id
  subscription_id         = var.subscription_id
  storage_account_name    = var.storage_account_name
  container_name          = var.container_name
  zookeeper_host_name     = var.zookeeper_host_name
  elasticsearch_host_name = var.elasticsearch_host_name
  playbooks               = var.playbooks
  depends_on              = [azurerm_linux_virtual_machine.linux_vm, module.disk]
}


module "vm_backup" {
  source                         = "./backup"
  count                          = var.vm_backup_required == true ? 1 : 0
  recovery_services_vault_name   = var.recovery_services_vault_name
  rg_location                    = var.rg_location
  vm_rg                          = var.vm_rg
  recovery_services_vault_sku    = var.recovery_services_vault_sku
  soft_delete_enabled            = var.soft_delete_enabled
  vm_backup_policy_name          = var.vm_backup_policy_name
  time_zone                      = var.time_zone
  instant_restore_retention_days = var.instant_restore_retention_days
  backup_frequency               = var.backup_frequency
  backup_time                    = var.backup_time
  retention_daily_count          = var.retention_daily_count
  virtual_machine_id             = azurerm_linux_virtual_machine.linux_vm.id
  depends_on                     = [azurerm_linux_virtual_machine.linux_vm, module.disk, module.ansible]
}
