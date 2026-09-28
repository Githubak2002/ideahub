# -----------------------------------------------------------------------------
# Root module input variables
# -----------------------------------------------------------------------------

# --- Project metadata --------------------------------------------------------

variable "project" {
  description = "Project name, used as a naming prefix for all resources."
  type        = string
  default     = "ideahub"
}

variable "environment" {
  description = "Deployment environment (dev, staging, prod)."
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

variable "location" {
  description = "Azure region for all resources."
  type        = string
  default     = "centralindia"
}

# --- Networking --------------------------------------------------------------

variable "vnet_address_space" {
  description = "Address space for the VNet."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "aks_subnet_prefix" {
  description = "CIDR prefix for the AKS subnet."
  type        = string
  default     = "10.0.1.0/24"
}

variable "vm_subnet_prefix" {
  description = "CIDR prefix for the Jump VM subnet."
  type        = string
  default     = "10.0.2.0/24"
}

# variable "ssh_source_cidr" {
#   description = "Source CIDR allowed to SSH into the Jump VM (e.g. your public IP/32)."
#   type        = string

#   validation {
#     condition     = can(cidrhost(var.ssh_source_cidr, 0))
#     error_message = "ssh_source_cidr must be a valid CIDR block."
#   }
# }

# --- AKS ---------------------------------------------------------------------

variable "aks_node_vm_size" {
  description = "VM size for the AKS system node pool."
  type        = string
  default     = "Standard_B2s"
}

variable "aks_node_count" {
  description = "Number of nodes in the AKS system node pool."
  type        = number
  default     = 1

  validation {
    condition     = var.aks_node_count >= 1 && var.aks_node_count <= 3
    error_message = "aks_node_count must be between 1 and 3 for this POC."
  }
}

variable "kubernetes_version" {
  description = "Kubernetes version for AKS. Set to null for latest."
  type        = string
  default     = null
}

# --- Cosmos DB ---------------------------------------------------------------

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

variable "cosmosdb_partition_key" {
  description = "Partition key path for the Cosmos DB container."
  type        = string
  default     = "/id"
}

# --- Jump VM -----------------------------------------------------------------

variable "vm_size" {
  description = "VM size for the Jump VM."
  type        = string
  default     = "Standard_B1s"
}

variable "vm_admin_username" {
  description = "Admin username for the Jump VM."
  type        = string
  default     = "azureuser"
}

variable "vm_ssh_public_key" {
  description = "SSH public key for the Jump VM (contents, not path)."
  type        = string
  sensitive   = true
}

# --- Workload Identity -------------------------------------------------------

variable "workload_namespace" {
  description = "Kubernetes namespace for the workload ServiceAccount."
  type        = string
  default     = "ideahub"
}

variable "workload_service_account" {
  description = "Kubernetes ServiceAccount name for workload identity."
  type        = string
  default     = "ideahub-sa"
}
