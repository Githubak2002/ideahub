# -----------------------------------------------------------------------------
# Root module — orchestrates all child modules
# -----------------------------------------------------------------------------
# Dependency order (no circular dependencies):
#   1. resource_group
#   2. networking (VNet, subnets, NSG)
#   3. identity (UAMIs + Network Contributor role — no FIC, no AKS dependency)
#   4. aks (uses identity.aks_infra_uami_id — AKS depends on identity)
#   5. federation (FIC — uses aks.oidc_issuer_url + identity.workload_uami_id)
#   6. cosmosdb (uses identity.workload_uami_principal_id for RBAC)
#   7. private_endpoint (uses cosmosdb.account_id + networking vnet/subnet)
#   8. jumpbox (uses networking vm_subnet)
# -----------------------------------------------------------------------------

# --- Resource Group ----------------------------------------------------------

module "resource_group" {
  source = "./modules/resource-group"

  project     = var.project
  environment = var.environment
  location    = var.location
  tags        = local.common_tags
}

# --- Networking (VNet, Subnets, NSG) -----------------------------------------

module "networking" {
  source = "./modules/networking"
  
  project             = var.project
  environment         = var.environment
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  vnet_address_space  = var.vnet_address_space
  aks_subnet_prefix   = var.aks_subnet_prefix
  vm_subnet_prefix    = var.vm_subnet_prefix
  # ssh_source_cidr     = var.ssh_source_cidr
  tags                = local.common_tags
}

# --- Identity (UAMIs + Network Contributor role) -----------------------------
# Creates UAMI #1 (AKS infra) and UAMI #2 (workload).
# No FIC here — that requires the AKS OIDC URL (created in federation module).

module "identity" {
  source = "./modules/identity"

  project             = var.project
  environment         = var.environment
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  aks_subnet_id       = module.networking.aks_subnet_id
  tags                = local.common_tags
}

# --- AKS (Private cluster with OIDC + Workload Identity) --------------------
# Depends on identity module for UAMI #1.

module "aks" {
  source = "./modules/aks"

  project             = var.project
  environment         = var.environment
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  aks_subnet_id       = module.networking.aks_subnet_id
  aks_infra_uami_id   = module.identity.aks_infra_uami_id
  node_vm_size        = var.aks_node_vm_size
  node_count          = var.aks_node_count
  kubernetes_version  = var.kubernetes_version
  tags                = local.common_tags
}

# --- Federation (Federated Identity Credential) -----------------------------
# Depends on AKS (for OIDC URL) and identity (for workload UAMI ID).
# Establishes trust: AKS OIDC → K8s ServiceAccount → UAMI #2.

module "federation" {
  source = "./modules/federation"

  project                  = var.project
  environment              = var.environment
  workload_uami_id         = module.identity.workload_uami_id
  aks_oidc_issuer_url      = module.aks.oidc_issuer_url
  workload_namespace       = var.workload_namespace
  workload_service_account = var.workload_service_account
}

# --- Cosmos DB (NoSQL + RBAC for workload UAMI) ------------------------------
# Depends on identity for workload UAMI principal_id.

module "cosmosdb" {
  source = "./modules/cosmosdb"

  project                    = var.project
  environment                = var.environment
  location                   = module.resource_group.location
  resource_group_name        = module.resource_group.name
  database_name              = var.cosmosdb_database_name
  container_name             = var.cosmosdb_container_name
  partition_key              = var.cosmosdb_partition_key
  workload_uami_principal_id = module.identity.workload_uami_principal_id
  tags                       = local.common_tags
}

# --- Private Endpoint + DNS (Cosmos DB) -------------------------------------

module "private_endpoint" {
  source = "./modules/private-endpoint"

  project             = var.project
  environment         = var.environment
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  vnet_id             = module.networking.vnet_id
  aks_subnet_id       = module.networking.aks_subnet_id
  cosmosdb_account_id = module.cosmosdb.account_id
  tags                = local.common_tags
}

# --- Jump VM (public SSH access to private VNet) -----------------------------

module "jumpbox" {
  source = "./modules/jumpbox"

  project             = var.project
  environment         = var.environment
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  vm_subnet_id        = module.networking.vm_subnet_id
  vm_size             = var.vm_size
  admin_username      = var.vm_admin_username
  ssh_public_key      = var.vm_ssh_public_key
  tags                = local.common_tags
}
