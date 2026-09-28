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

variable "pod_cidr" {
  description = "CIDR range used for AKS pod IPs with Azure CNI Overlay"
  type        = string
  default     = "10.10.0.0/16"
}

variable "service_cidr" {
  description = "CIDR range used for Kubernetes Services"
  type        = string
  default     = "10.20.0.0/16"
}

variable "dns_service_ip" {
  description = "Kubernetes DNS service IP"
  type        = string
  default     = "10.20.0.10"
}