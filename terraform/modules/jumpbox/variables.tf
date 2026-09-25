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

variable "vm_subnet_id" {
  description = "ID of the VM subnet."
  type        = string
}

variable "vm_size" {
  description = "VM size."
  type        = string
  default     = "Standard_B1s"
}

variable "admin_username" {
  description = "Admin username."
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key" {
  description = "SSH public key content."
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
