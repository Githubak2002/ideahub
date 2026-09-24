# -----------------------------------------------------------------------------
# Resource Group
# -----------------------------------------------------------------------------

resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location

  tags = local.common_tags
}

# -----------------------------------------------------------------------------
# Common tags applied to every resource
# -----------------------------------------------------------------------------

locals {
  common_tags = {
    environment = var.environment
    owner       = var.owner
    managed-by  = "terraform"
    project     = "aks-cosmosdb-workload-identity"
  }
}
