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

variable "database_name" {
  description = "Cosmos DB SQL database name."
  type        = string
  default     = "ideahub"
}

variable "container_name" {
  description = "Cosmos DB SQL container name."
  type        = string
  default     = "ideas"
}

variable "partition_key" {
  description = "Partition key path."
  type        = string
  default     = "/id"
}

variable "workload_uami_principal_id" {
  description = "Principal ID of the workload UAMI for Cosmos DB RBAC."
  type        = string
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
