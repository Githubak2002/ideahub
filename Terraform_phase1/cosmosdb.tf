# -----------------------------------------------------------------------------
# Cosmos DB Account  (NoSQL / SQL API — dev-optimised)
# -----------------------------------------------------------------------------
# Configuration verified against the official AzureRM 5.5 provider documentation
# via the HashiCorp Terraform MCP server (provider_doc_id: 13599774).
#
# Cost-saving choices for dev/demo:
#   • EnableServerless capability  — pay only for consumed RU/s, no minimum
#   • Single-region (no geo-replication)
#   • Session consistency (cheapest multi-read level, good enough for dev)
#   • free_tier_enabled = true   — 1000 RU/s + 25 GB free (one per subscription)
#   • Periodic backup with local redundancy (cheapest backup option)
# -----------------------------------------------------------------------------

resource "azurerm_cosmosdb_account" "this" {
  name                = var.cosmosdb_account_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB" # NoSQL / SQL API

  # --- Cost optimisation -------------------------------------------------------
  free_tier_enabled = true # 1 free-tier account per subscription

  capabilities {
    name = "EnableServerless" # Pay-per-request, no provisioned throughput
  }

  # --- Consistency -------------------------------------------------------------
  consistency_policy {
    consistency_level = "Session"
  }

  # --- Geo-location (single region for dev) ------------------------------------
  geo_location {
    location          = azurerm_resource_group.this.location
    failover_priority = 0
  }

  # --- Network (public for local dev phase) ------------------------------------
  public_network_access_enabled = true

  # --- Authentication ----------------------------------------------------------
  # Key-based auth enabled for local FastAPI testing.
  # Will be switched to RBAC / Workload Identity in the private AKS phase.
  local_authentication_enabled = true

  # --- Backup ------------------------------------------------------------------
  backup {
    type                = "Periodic"
    interval_in_minutes = 1440 # every 24 h — minimum cost
    retention_in_hours  = 8    # minimum retention
    storage_redundancy  = "Local"
  }

  tags = local.common_tags
}

# -----------------------------------------------------------------------------
# SQL Database
# -----------------------------------------------------------------------------
# Verified against AzureRM 5.5 docs (provider_doc_id: 13599791).
# Throughput is NOT set because the account uses Serverless capability.
# -----------------------------------------------------------------------------

resource "azurerm_cosmosdb_sql_database" "this" {
  name                = var.cosmosdb_database_name
  resource_group_name = azurerm_resource_group.this.name
  account_name        = azurerm_cosmosdb_account.this.name
}

# -----------------------------------------------------------------------------
# SQL Container
# -----------------------------------------------------------------------------
# Verified against AzureRM 5.5 docs (provider_doc_id: 13599790).
# Throughput is NOT set because the account uses Serverless capability.
# partition_key_paths uses the list format required by AzureRM 5.x.
# -----------------------------------------------------------------------------

resource "azurerm_cosmosdb_sql_container" "this" {
  name                = var.cosmosdb_container_name
  resource_group_name = azurerm_resource_group.this.name
  account_name        = azurerm_cosmosdb_account.this.name
  database_name       = azurerm_cosmosdb_sql_database.this.name
  partition_key_paths = [var.cosmosdb_container_partition_key]

  # Default indexing is fine for a dev workload
  indexing_policy {
    indexing_mode = "consistent"

    included_path {
      path = "/*"
    }

    excluded_path {
      path = "/\"_etag\"/?"
    }
  }
}
