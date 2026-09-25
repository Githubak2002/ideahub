output "private_endpoint_id" {
  description = "ID of the Cosmos DB private endpoint."
  value       = azurerm_private_endpoint.cosmos.id
}

output "private_ip_address" {
  description = "Private IP address of the Cosmos DB private endpoint."
  value       = azurerm_private_endpoint.cosmos.private_service_connection[0].private_ip_address
}

output "private_dns_zone_id" {
  description = "ID of the private DNS zone."
  value       = azurerm_private_dns_zone.cosmos.id
}
