resource "azurerm_network_security_group" "main" {
  name                = var.network_security_group_name
  location            = var.rg_location
  resource_group_name = var.vm_rg

  dynamic "security_rule" {
    for_each = var.security_rule
    content {
      name                       = security_rule.value["name"]
      priority                   = security_rule.value["priority"]
      direction                  = security_rule.value["direction"]
      access                     = security_rule.value["access"]
      protocol                   = security_rule.value["protocol"]
      source_port_range          = security_rule.value["source_port_range"]
      destination_port_range     = security_rule.value["destination_port_range"]
      source_address_prefix      = security_rule.value["source_address_prefix"]
      destination_address_prefix = security_rule.value["destination_address_prefix"]
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "main" {
  subnet_id                 = data.azurerm_subnet.main.id
  network_security_group_id = azurerm_network_security_group.main.id
  depends_on                = [azurerm_network_security_group.main]
}
