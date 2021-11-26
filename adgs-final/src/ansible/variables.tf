variable "vm_private_ip_address" {
  type = string
}

variable "vm_admin_username" {
  type = string
}

variable "vm_password" {
  type = string
}

variable "vm_packages" {
  type = list(string)
}

variable "client_id" {
  type = string
}

variable "client_secret" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "subscription_id" {
  type = string
}

variable "storage_account_name" {
  type = string
}

variable "container_name" {
  type = string
}


variable "playbooks" {
  type = list(string)
}

variable "zookeeper_host_name" {
  type = string
}

variable "elasticsearch_host_name" {
  type = string
}


