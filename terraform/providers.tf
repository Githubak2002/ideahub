# -----------------------------------------------------------------------------
# AzureRM provider configuration
# -----------------------------------------------------------------------------
# Authentication is handled via the Azure CLI, environment variables, or
# Managed Identity — no credentials are stored in this file.
#
# The subscription_id is intentionally NOT hardcoded.  Set it via:
#   - ARM_SUBSCRIPTION_ID environment variable, or
#   - az account set --subscription <id>
# -----------------------------------------------------------------------------

provider "azurerm" {
  features {

  }
}
