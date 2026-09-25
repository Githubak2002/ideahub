# -----------------------------------------------------------------------------
# AzureRM provider configuration
# -----------------------------------------------------------------------------
# Authentication: Azure CLI / environment variables / Managed Identity.
# No credentials stored in this file.
#
# Set subscription via:
#   ARM_SUBSCRIPTION_ID env var, or
#   az account set --subscription <id>
# -----------------------------------------------------------------------------

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}
