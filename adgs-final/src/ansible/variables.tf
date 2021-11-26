variable "vm_private_ip_address" {
  type        = string
  description = "virtual machine ip address"
}

variable "vm_admin_username" {
  type        = string
  description = "vm hostname"
}

variable "vm_password" {
  type        = string
  description = "virtual machine password"
}

variable "vm_packages" {
  type        = list(string)
  description = "list of required packages need to be downlaoded in vm"
}

variable "client_id" {
  type        = string
  description = "client id"
}

variable "client_secret" {
  type        = string
  description = "client secret"
}

variable "tenant_id" {
  type        = string
  description = "tenant id"
}

variable "subscription_id" {
  type        = string
  description = "subscription id"
}

variable "storage_account_name" {
  type        = string
  description = "storage account name where the packages are uploaded"
}

variable "container_name" {
  type        = string
  description = "conatiner name"
}

#updating files
variable "playbooks" {
  type        = list(string)
  description = "list of playbooks to be executed by ansible script"
}

variable "zookeeper_host_name" {
  type        = string
  description = "zookeeper host name"
}

variable "elasticsearch_host_name" {
  type        = string
  description = "elasticsearch host name"
}


