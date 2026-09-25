variable "project" {
  description = "Project name."
  type        = string
}

variable "environment" {
  description = "Deployment environment."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group."
  type        = string
}

variable "vnet_address_space" {
  description = "Address space for the VNet."
  type        = list(string)
}

variable "aks_subnet_prefix" {
  description = "CIDR for the AKS subnet."
  type        = string
}

variable "vm_subnet_prefix" {
  description = "CIDR for the VM subnet."
  type        = string
}

variable "ssh_source_cidr" {
  description = "Source CIDR allowed for SSH."
  type        = string
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
