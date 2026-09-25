# -----------------------------------------------------------------------------
# UAMI #1 — AKS infrastructure identity (BYO VNet)
# -----------------------------------------------------------------------------
# Assigned to AKS cluster. Needs Network Contributor on AKS subnet so
# AKS can join pods to the BYO VNet/subnet.
# This module is created BEFORE AKS (no dependency on AKS).
# -----------------------------------------------------------------------------

resource "azurerm_user_assigned_identity" "aks_infra" {
  name                = "${var.project}-${var.environment}-aks-infra-uami"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_role_assignment" "aks_network_contributor" {
  scope                            = var.aks_subnet_id
  role_definition_name             = "Network Contributor"
  principal_id                     = azurerm_user_assigned_identity.aks_infra.principal_id
  skip_service_principal_aad_check = true
}

# -----------------------------------------------------------------------------
# UAMI #2 — Application workload identity
# -----------------------------------------------------------------------------
# Represents the FastAPI application. Will be federated with AKS OIDC
# and given Cosmos DB data-plane RBAC. No infrastructure permissions.
# This is also created BEFORE AKS (no dependency on AKS).
# -----------------------------------------------------------------------------

resource "azurerm_user_assigned_identity" "workload" {
  name                = "${var.project}-${var.environment}-aks-workload-uami"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}
