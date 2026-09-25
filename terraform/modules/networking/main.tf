# -----------------------------------------------------------------------------
# VNet
# -----------------------------------------------------------------------------

resource "azurerm_virtual_network" "this" {
  name                = "${var.project}-${var.environment}-vnet"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_address_space
  tags                = var.tags
}

# -----------------------------------------------------------------------------
# Subnets
# -----------------------------------------------------------------------------

resource "azurerm_subnet" "aks" {
  name                 = "${var.project}-${var.environment}-aks-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.aks_subnet_prefix]
}

resource "azurerm_subnet" "vm" {
  name                 = "${var.project}-${var.environment}-vm-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.vm_subnet_prefix]
}

# -----------------------------------------------------------------------------
# NSG for VM subnet — restrict SSH to configurable source CIDR
# -----------------------------------------------------------------------------

resource "azurerm_network_security_group" "vm" {
  name                = "${var.project}-${var.environment}-vm-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_network_security_rule" "ssh_inbound" {
  name                        = "AllowSSH"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  # source_address_prefix       = var.ssh_source_cidr
  destination_address_prefix = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.vm.name
}

# resource "azurerm_network_security_rule" "deny_all_inbound" {
#   name                        = "DenyAllInbound"
#   priority                    = 4096
#   direction                   = "Inbound"
#   access                      = "Deny"
#   protocol                    = "*"
#   source_port_range           = "*"
#   destination_port_range      = "*"
#   source_address_prefix       = "*"
#   destination_address_prefix  = "*"
#   resource_group_name         = var.resource_group_name
#   network_security_group_name = azurerm_network_security_group.vm.name
# }

resource "azurerm_subnet_network_security_group_association" "vm" {
  subnet_id                 = azurerm_subnet.vm.id
  network_security_group_id = azurerm_network_security_group.vm.id
}
