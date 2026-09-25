# -----------------------------------------------------------------------------
# Terraform and provider version constraints
# -----------------------------------------------------------------------------
# Terraform CLI : >= 1.5.0
# AzureRM       : ~> 5.5 (verified via HashiCorp Terraform MCP Server)
# -----------------------------------------------------------------------------

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.5"
    }
  }
}
