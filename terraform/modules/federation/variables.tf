variable "project" {
  description = "Project name."
  type        = string
}

variable "environment" {
  description = "Deployment environment."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group."
  type        = string
}

variable "workload_uami_id" {
  description = "Resource ID of the workload UAMI (parent for FIC)."
  type        = string
}

variable "aks_oidc_issuer_url" {
  description = "OIDC issuer URL from the AKS cluster."
  type        = string
}

variable "workload_namespace" {
  description = "Kubernetes namespace for the workload ServiceAccount."
  type        = string
}

variable "workload_service_account" {
  description = "Kubernetes ServiceAccount name for workload identity."
  type        = string
}
