# -----------------------------------------------------------------------------
# Terraform and provider version constraints
# -----------------------------------------------------------------------------
# Terraform CLI : >= 1.5.0 (broad compatibility; HCL features used here are
#                 stable since 1.5, which also introduced import blocks)
# AzureRM       : ~> 5.5 (verified via HashiCorp Terraform MCP Server;
#                 latest version is 5.5.0 as of 2026-09-17)
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
