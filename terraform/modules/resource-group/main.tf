resource "azurerm_resource_group" "this" {
  name     = "${var.project}-${var.environment}-rg"
  location = var.location
  tags     = var.tags
}
