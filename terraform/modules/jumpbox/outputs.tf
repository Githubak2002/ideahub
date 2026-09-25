output "public_ip" {
  description = "Public IP of the Jump VM."
  value       = azurerm_public_ip.this.ip_address
}

output "vm_name" {
  description = "Name of the Jump VM."
  value       = azurerm_linux_virtual_machine.this.name
}

output "ssh_command" {
  description = "SSH command to connect to the Jump VM."
  value       = "ssh ${var.admin_username}@${azurerm_public_ip.this.ip_address}"
}
