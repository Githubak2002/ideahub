output "account_id" {
  description = "ID of the Cosmos DB account."
  value       = azurerm_cosmosdb_account.this.id
}

output "account_name" {
  description = "Name of the Cosmos DB account."
  value       = azurerm_cosmosdb_account.this.name
}

output "endpoint" {
  description = "Cosmos DB account endpoint (COSMOS_ENDPOINT)."
  value       = azurerm_cosmosdb_account.this.endpoint
}

output "primary_key" {
  description = "Primary key (for migration only). Treat as secret."
  value       = azurerm_cosmosdb_account.this.primary_key
  sensitive   = true
}

output "database_name" {
  description = "Name of the SQL database."
  value       = azurerm_cosmosdb_sql_database.this.name
}

output "container_name" {
  description = "Name of the SQL container."
  value       = azurerm_cosmosdb_sql_container.this.name
}
