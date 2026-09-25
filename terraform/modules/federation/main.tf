# -----------------------------------------------------------------------------
# Federated Identity Credential
# -----------------------------------------------------------------------------
# Trust between AKS OIDC issuer and the workload UAMI.
# This module runs AFTER AKS is created (needs OIDC issuer URL).
#
# Subject: system:serviceaccount:<namespace>:<service-account>
# Audience: api://AzureADTokenExchange (standard Azure Workload Identity)
# -----------------------------------------------------------------------------

resource "azurerm_federated_identity_credential" "workload" {
  name                = "${var.project}-${var.environment}-federated-cred"
  resource_group_name = var.resource_group_name
  parent_id           = var.workload_uami_id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.aks_oidc_issuer_url
  subject             = "system:serviceaccount:${var.workload_namespace}:${var.workload_service_account}"
}
