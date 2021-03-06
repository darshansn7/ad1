
#############################################################################
####################     update main.yml   #################################
#############################################################################
data "template_file" "playbooks" {
  template = <<EOF
- hosts: all
  gather_facts: no
  become: yes
  become_method: sudo 

%{for yaml in var.playbooks~}
- import_playbook: ${yaml}
%{endfor~}
EOF
}


resource "local_file" "playbooks" {
  filename = "${path.module}/playbooks/main.yml"
  content  = data.template_file.playbooks.template
}

#############################################################################
####################     update hosts  #################################
#############################################################################
data "template_file" "hosts" {
  template = <<EOF
[default]
${var.vm_private_ip_address}
[default:vars]
ansible_user=${var.vm_admin_username}
ansible_password=${var.vm_password}
ansible_sudo_pass=${var.vm_password}
EOF
}

resource "local_file" "hosts" {
  filename = "${path.module}/inventory/hosts"
  content  = data.template_file.hosts.template
}

#############################################################################
####################     update vars.yml   #################################
#############################################################################
data "template_file" "vars_yaml" {
  template = <<EOF
zookeeper: "${var.zookeeper_host_name}"
elasticsearch: "${var.elasticsearch_host_name}"
aspire_download_url: "aspire-4.0-SNAPSHOT.tar.gz"
saga_download_url: "Saga_Server.zip"
elastic_data_url: "elasticsearch-7.2.1-x86_64.rpm"
zookeeper_download_link: "apache-zookeeper-3.5.6-bin.tar.gz" 
EOF
}

resource "local_file" "update_vars_yaml" {
  content  = data.template_file.vars_yaml.template
  filename = "${path.module}/playbooks/vars.yml"
}

