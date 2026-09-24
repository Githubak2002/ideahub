# -----------------------------------------------------------------------------
# Outputs
# -----------------------------------------------------------------------------
# Only values needed by downstream consumers (FastAPI .env, CI/CD, etc.).
# Keys are marked sensitive so they are redacted in CLI output and logs.
# -----------------------------------------------------------------------------

output "cosmosdb_endpoint" {
  description = "Cosmos DB account endpoint URL (COSMOS_ENDPOINT)."
  value       = azurerm_cosmosdb_account.this.endpoint
}

output "cosmosdb_primary_key" {
  description = "Cosmos DB primary key (COSMOS_KEY). Treat as a secret."
  value       = azurerm_cosmosdb_account.this.primary_key
  sensitive   = true
}

output "cosmosdb_connection_string" {
  description = "Primary SQL connection string. Treat as a secret."
  value       = azurerm_cosmosdb_account.this.primary_sql_connection_string
  sensitive   = true
}

output "cosmosdb_database_name" {
  description = "Name of the provisioned Cosmos DB SQL database."
  value       = azurerm_cosmosdb_sql_database.this.name
}

output "cosmosdb_container_name" {
  description = "Name of the provisioned Cosmos DB SQL container."
  value       = azurerm_cosmosdb_sql_container.this.name
}

output "resource_group_name" {
  description = "Name of the Azure resource group."
  value       = azurerm_resource_group.this.name
}
