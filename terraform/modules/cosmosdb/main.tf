# -----------------------------------------------------------------------------
# Cosmos DB Account (NoSQL / SQL API — Phase 2 POC)
# -----------------------------------------------------------------------------
# - Serverless (pay-per-request, cheapest for POC)
# - Free tier enabled (1 per subscription; applies to provisioned throughput,
#   but does no harm on Serverless accounts)
# - Public access enabled initially for migration safety
# - Key auth enabled initially (will be disabled after WI verification)
# - Single region
#
# MCP-verified: azurerm_cosmosdb_account (provider_doc_id: 13599774)
# MCP-verified: azurerm_cosmosdb_sql_database (provider_doc_id: 13599791)
# MCP-verified: azurerm_cosmosdb_sql_container (provider_doc_id: 13599790)
# MCP-verified: azurerm_cosmosdb_sql_role_assignment — built-in Data Contributor
#   role UUID: 00000000-0000-0000-0000-000000000002
# -----------------------------------------------------------------------------

resource "azurerm_cosmosdb_account" "this" {
  name                = "${var.project}-${var.environment}-cosmos"
  location            = var.location
  resource_group_name = var.resource_group_name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  free_tier_enabled = true

  capabilities {
    name = "EnableServerless"
  }

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = var.location
    failover_priority = 0
  }

  # Public access enabled during migration; will be restricted later
  public_network_access_enabled = true

  # Key auth left enabled for safe migration from Phase 1.
  # Set to true to disable key auth after Workload Identity verification.
  local_authentication_disabled = false

  backup {
    type                = "Periodic"
    interval_in_minutes = 1440
    retention_in_hours  = 8
    storage_redundancy  = "Local"
  }

  tags = var.tags
}

# -----------------------------------------------------------------------------
# SQL Database — no throughput (Serverless)
# -----------------------------------------------------------------------------

resource "azurerm_cosmosdb_sql_database" "this" {
  name                = var.database_name
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.this.name
}

# -----------------------------------------------------------------------------
# SQL Container — no throughput (Serverless)
# -----------------------------------------------------------------------------

resource "azurerm_cosmosdb_sql_container" "this" {
  name                = var.container_name
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.this.name
  database_name       = azurerm_cosmosdb_sql_database.this.name
  partition_key_paths = [var.partition_key]

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

# -----------------------------------------------------------------------------
# Cosmos DB Data-Plane RBAC
# -----------------------------------------------------------------------------
# Built-in "Cosmos DB Built-in Data Contributor" role:
#   UUID: 00000000-0000-0000-0000-000000000002
# Grants: create, read, query, delete items (full data-plane access)
# Scope: Cosmos DB account level (narrowest practical for data-plane)
#
# This is data-plane RBAC, NOT Azure management-plane RBAC.
# -----------------------------------------------------------------------------

resource "azurerm_cosmosdb_sql_role_assignment" "workload_data_contributor" {
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.this.name
  role_definition_id  = "${azurerm_cosmosdb_account.this.id}/sqlRoleDefinitions/00000000-0000-0000-0000-000000000002"
  principal_id        = var.workload_uami_principal_id
  scope               = azurerm_cosmosdb_account.this.id
}
