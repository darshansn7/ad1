data "azurerm_subnet" "main" {
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.vm_rg
}

# data "azurerm_key_vault" "main" {
#   name                = var.key_vault_name
#   resource_group_name = var.vm_rg
# }
