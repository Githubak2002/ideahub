# -----------------------------------------------------------------------------
# Public IP for Jump VM
# -----------------------------------------------------------------------------

resource "azurerm_public_ip" "this" {
  name                = "${var.project}-${var.environment}-jumpbox-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Basic"
  tags                = var.tags
}

# -----------------------------------------------------------------------------
# NIC for Jump VM
# -----------------------------------------------------------------------------

resource "azurerm_network_interface" "this" {
  name                = "${var.project}-${var.environment}-jumpbox-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.vm_subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.this.id
  }

  tags = var.tags
}

# -----------------------------------------------------------------------------
# Linux Jump VM
# -----------------------------------------------------------------------------
# Purpose: SSH jump host to access private AKS cluster from internet.
# Tools installed via cloud-init: Azure CLI, kubectl, curl, jq.
# Password auth disabled; SSH key only.
# -----------------------------------------------------------------------------

resource "azurerm_linux_virtual_machine" "this" {
  name                = "${var.project}-${var.environment}-jumpbox"
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = var.vm_size
  admin_username      = var.admin_username

  network_interface_ids = [
    azurerm_network_interface.this.id,
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 30
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  disable_password_authentication = true

  custom_data = base64encode(file("${path.module}/cloud-init.yaml"))

  tags = var.tags
}
