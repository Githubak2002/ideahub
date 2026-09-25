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

variable "vnet_id" {
  description = "ID of the VNet for DNS zone link."
  type        = string
}

variable "aks_subnet_id" {
  description = "ID of the subnet for the private endpoint."
  type        = string
}

variable "cosmosdb_account_id" {
  description = "Resource ID of the Cosmos DB account."
  type        = string
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
