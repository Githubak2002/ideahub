# -----------------------------------------------------------------------------
# Input variables
# -----------------------------------------------------------------------------

variable "resource_group_name" {
  description = "Name of the Azure resource group."
  type        = string

  validation {
    condition     = length(var.resource_group_name) > 0
    error_message = "resource_group_name must not be empty."
  }
}

variable "location" {
  description = "Azure region for all resources."
  type        = string
  default     = "centralindia"
}

variable "cosmosdb_account_name" {
  description = "Globally-unique name for the Cosmos DB account."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]{3,44}$", var.cosmosdb_account_name))
    error_message = "cosmosdb_account_name must be 3-44 characters, lowercase letters, digits, and hyphens only."
  }
}

variable "cosmosdb_database_name" {
  description = "Name of the Cosmos DB SQL database."
  type        = string
  default     = "ideahub"
}

variable "cosmosdb_container_name" {
  description = "Name of the Cosmos DB SQL container."
  type        = string
  default     = "ideas"
}

variable "cosmosdb_container_partition_key" {
  description = "Partition key path for the SQL container."
  type        = string
  default     = "/id"
}

variable "environment" {
  description = "Deployment environment label (e.g. dev, staging, prod)."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, staging, prod."
  }
}

variable "owner" {
  description = "Team or individual owning these resources."
  type        = string
  default     = "platform-team"
}
