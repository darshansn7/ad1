resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#&)/?_%@"
}
################################################
# Create keypair (generate if needed)
################################################
resource "null_resource" "create_key_file" {
  count = var.vm_public_key == "" ? 1 : 0
  provisioner "local-exec" {
    command     = "mkdir -p ${abspath(path.root)}/${var.virtual_machine_name}"
    interpreter = ["/bin/bash", "-c"]
    working_dir = path.module
  }
  provisioner "local-exec" {
    command     = "openssl genrsa -out ${abspath(path.root)}/${var.virtual_machine_name}/${local.vm_name}.pem 4096"
    interpreter = ["/bin/bash", "-c"]
    working_dir = path.module
  }
  provisioner "local-exec" {
    command     = "sudo chmod 600 ${abspath(path.root)}/${var.virtual_machine_name}/${local.vm_name}.pem"
    interpreter = ["/bin/bash", "-c"]
    working_dir = path.module
  }
  provisioner "local-exec" {
    command     = "ssh-keygen -y -f ${abspath(path.root)}/${var.virtual_machine_name}/${local.vm_name}.pem > ${abspath(path.root)}/${var.virtual_machine_name}/${local.vm_name}.pub"
    interpreter = ["/bin/bash", "-c"]
    working_dir = path.module
  }
  provisioner "local-exec" {
    command     = "sudo chmod 600 ${abspath(path.root)}/${var.virtual_machine_name}/${local.vm_name}.pub"
    interpreter = ["/bin/bash", "-c"]
    working_dir = path.module
  }
}

locals {
  vm_name     = var.virtual_machine_name
  public_key  = sensitive(var.vm_public_key == "" ? data.local_file.public_key[0].content : var.vm_public_key)
  private_key = sensitive(var.vm_private_key == "" ? data.local_file.private_key[0].content : var.vm_private_key)
}

data "local_file" "private_key" {
  count      = var.vm_private_key == "" ? 1 : 0
  filename   = "${abspath(path.root)}/${var.virtual_machine_name}/${local.vm_name}.pem"
  depends_on = [null_resource.create_key_file]
}

data "local_file" "public_key" {
  count      = var.vm_public_key == "" ? 1 : 0
  filename   = "${abspath(path.root)}/${var.virtual_machine_name}/${local.vm_name}.pub"
  depends_on = [null_resource.create_key_file]
}
resource "azurerm_ssh_public_key" "main" {
  name                = local.vm_name
  resource_group_name = var.vm_rg
  location            = var.rg_location
  public_key          = local.public_key
  depends_on          = [null_resource.create_key_file]
}

# resource "azurerm_key_vault_secret" "public_key" {
#   count        = var.vm_public_key == "" ? 1 : 0
#   name         = local.vm_name
#   value        = base64encode(local.private_key)
#   key_vault_id = data.azurerm_key_vault.main.id
#   depends_on   = [null_resource.create_key_file, azurerm_linux_virtual_machine.linux_vm]
# }

# resource "azurerm_key_vault_secret" "private_key" {
#   count        = var.vm_private_key == "" ? 1 : 0
#   name         = local.vm_name
#   value        = base64encode(local.private_key)
#   key_vault_id = data.azurerm_key_vault.main.id
#   depends_on   = [null_resource.create_key_file, azurerm_linux_virtual_machine.linux_vm]
# }

#push vm password to keyvault
# resource "azurerm_key_vault_secret" "push_vm_passowrd" {
#   name         = var.keyvault_vm_secret
#   value        = sensitive(random_password.password.result)
#   key_vault_id = data.azurerm_key_vault.main.id
#   depends_on   = [null_resource.create_key_file, azurerm_linux_virtual_machine.linux_vm]
# }

