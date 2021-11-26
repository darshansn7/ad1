#############################################################################
####################           ansible    ###################################
#############################################################################

resource "null_resource" "azcli" {
  triggers = { always_run = "${timestamp()}" }
  provisioner "remote-exec" {
    inline = ["echo 'build ssh connection' "]
  }

  connection {
    host     = var.vm_private_ip_address
    type     = "ssh"
    user     = var.vm_admin_username
    password = var.vm_password
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i ${path.module}/inventory/hosts ${path.module}/azcli.yml"
  }
  depends_on = [null_resource.packages_download, local_file.update_vars_yaml, local_file.playbooks,local_file.hosts ]
}



resource "null_resource" "packages_download" {
  count = length(var.vm_packages)
  provisioner "remote-exec" {
    inline = ["echo 'build ssh connection' "]
  }

  connection {
    host     = var.vm_private_ip_address
    type     = "ssh"
    user     = var.vm_admin_username
    password = var.vm_password
  }

  #download package
  provisioner "remote-exec" {
    inline = ["cd /tmp",
      "az login --service-principal --username '${var.client_id}' --password '${var.client_secret}' --tenant '${var.tenant_id}'",
      "az account set --subscription '${var.subscription_id}'",
      "az account list --output table",
      "az storage blob download --account-name '${var.storage_account_name}' --container-name '${var.container_name}' --name '${var.vm_packages[count.index]}' --file '${var.vm_packages[count.index]}'"
    ]
  }
  depends_on = [null_resource.azcli]
}

resource "null_resource" "install_package" {
  triggers = { always_run = "${timestamp()}" }
  provisioner "remote-exec" {
    inline = ["echo 'build ssh connection' "]
  }

  connection {
    host     = var.vm_private_ip_address
    type     = "ssh"
    user     = var.vm_admin_username
    password = var.vm_password
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i hosts ${path.module}/main.yml"
  }
  depends_on = [null_resource.packages_download, local_file.update_vars_yaml, local_file.playbooks]
}
