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

variable "aks_subnet_id" {
  description = "ID of the AKS subnet (BYO VNet)."
  type        = string
}

variable "aks_infra_uami_id" {
  description = "Resource ID of the AKS infrastructure UAMI."
  type        = string
}

variable "node_vm_size" {
  description = "VM size for the system node pool."
  type        = string
  default     = "Standard_B2s"
}

variable "node_count" {
  description = "Number of nodes in the system node pool."
  type        = number
  default     = 1
}

variable "kubernetes_version" {
  description = "Kubernetes version. null = latest."
  type        = string
  default     = null
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
