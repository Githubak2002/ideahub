# -----------------------------------------------------------------------------
# Private AKS Cluster
# -----------------------------------------------------------------------------
# - Private cluster (API server not exposed to internet)
# - BYO VNet / subnet
# - OIDC issuer enabled (for workload identity)
# - Workload identity enabled
# - UserAssigned identity (UAMI #1) for infrastructure
# - Single system node pool, cost-optimised for Student subscription POC
# -----------------------------------------------------------------------------

resource "azurerm_kubernetes_cluster" "this" {
  name                = "${var.project}-${var.environment}-aks"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.project}-${var.environment}"

  kubernetes_version = var.kubernetes_version

  # --- Private cluster -------------------------------------------------------
  private_cluster_enabled = true

  # --- Workload Identity + OIDC ----------------------------------------------
  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  # --- Identity (UserAssigned for BYO VNet) ----------------------------------
  identity {
    type         = "UserAssigned"
    identity_ids = [var.aks_infra_uami_id]
  }

  # --- Default node pool (system, cost-optimised) ----------------------------
  default_node_pool {
    name                        = "system"
    vm_size                     = var.node_vm_size
    node_count                  = var.node_count
    vnet_subnet_id              = var.aks_subnet_id
    os_disk_size_gb             = 30
    temporary_name_for_rotation = "tmpsystem"
  }

  # --- Network profile -------------------------------------------------------
  network_profile {
    network_plugin = "azure"
  }

  # --- Node provisioning profile (required in AzureRM >= 5.7) ----------------
  # Manual = standard node pools, no auto-provisioning (cost-optimised POC)
  node_provisioning_profile {
    mode = "Manual"
  }

  tags = var.tags
}
