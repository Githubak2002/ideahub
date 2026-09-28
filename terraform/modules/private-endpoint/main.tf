# -----------------------------------------------------------------------------
# Private DNS Zone for Cosmos DB
# -----------------------------------------------------------------------------
# Azure Cosmos DB NoSQL requires: privatelink.documents.azure.com
# (official Azure Private DNS zone name for SQL/Core API)
# MCP-verified: azurerm_private_dns_zone, azurerm_private_endpoint
# -----------------------------------------------------------------------------

resource "azurerm_private_dns_zone" "cosmos" {
  name                = "privatelink.documents.azure.com"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# -----------------------------------------------------------------------------
# VNet Link — DNS resolution from within the VNet
# -----------------------------------------------------------------------------

resource "azurerm_private_dns_zone_virtual_network_link" "cosmos" {
  name                 = "${var.project}-${var.environment}-cosmos-dns-link"
  private_dns_zone_id  = azurerm_private_dns_zone.cosmos.id
  virtual_network_id   = var.vnet_id
  registration_enabled = false
  tags                 = var.tags
}

# -----------------------------------------------------------------------------
# Private Endpoint for Cosmos DB
# -----------------------------------------------------------------------------
# subresource_names = ["Sql"] for Cosmos DB NoSQL/SQL API (case-sensitive)
# private_dns_zone_group auto-creates DNS A records in the linked zone
# -----------------------------------------------------------------------------

resource "azurerm_private_endpoint" "cosmos" {
  name                = "${var.project}-${var.environment}-cosmos-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.aks_subnet_id

  private_service_connection {
    name                           = "${var.project}-${var.environment}-cosmos-psc"
    private_connection_resource_id = var.cosmosdb_account_id
    is_manual_connection           = false
    subresource_names              = ["Sql"]
  }

  private_dns_zone_group {
    name                 = "cosmos-dns-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.cosmos.id]
  }

  tags = var.tags
}
