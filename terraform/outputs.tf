# -----------------------------------------------------------------------------
# Outputs — consumer-facing values for downstream phases
# -----------------------------------------------------------------------------

# --- Resource Group ----------------------------------------------------------

output "resource_group_name" {
  description = "Name of the resource group."
  value       = module.resource_group.name
}

# --- Networking --------------------------------------------------------------

output "vnet_name" {
  description = "Name of the VNet."
  value       = module.networking.vnet_name
}

# --- AKS ---------------------------------------------------------------------

output "aks_cluster_name" {
  description = "Name of the AKS cluster."
  value       = module.aks.cluster_name
}

output "aks_oidc_issuer_url" {
  description = "OIDC issuer URL for AKS workload identity."
  value       = module.aks.oidc_issuer_url
}

output "aks_get_credentials_command" {
  description = "az CLI command to get AKS credentials (run from Jump VM)."
  value       = "az aks get-credentials --resource-group ${module.resource_group.name} --name ${module.aks.cluster_name}"
}

# --- Identity ----------------------------------------------------------------

output "workload_uami_client_id" {
  description = "Client ID of the workload UAMI (for K8s ServiceAccount annotation)."
  value       = module.identity.workload_uami_client_id
}

# --- Cosmos DB ---------------------------------------------------------------

output "cosmosdb_endpoint" {
  description = "Cosmos DB account endpoint (COSMOS_ENDPOINT)."
  value       = module.cosmosdb.endpoint
}

output "cosmosdb_primary_key" {
  description = "Cosmos DB primary key (for migration only). Treat as secret."
  value       = module.cosmosdb.primary_key
  sensitive   = true
}

output "cosmosdb_database_name" {
  description = "Name of the Cosmos DB SQL database."
  value       = module.cosmosdb.database_name
}

output "cosmosdb_container_name" {
  description = "Name of the Cosmos DB SQL container."
  value       = module.cosmosdb.container_name
}

# --- Jump VM -----------------------------------------------------------------

output "jumpbox_public_ip" {
  description = "Public IP of the Jump VM."
  value       = module.jumpbox.public_ip
}

output "jumpbox_ssh_command" {
  description = "SSH command to connect to the Jump VM."
  value       = module.jumpbox.ssh_command
}
