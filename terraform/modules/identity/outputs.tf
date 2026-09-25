output "aks_infra_uami_id" {
  description = "Resource ID of the AKS infrastructure UAMI."
  value       = azurerm_user_assigned_identity.aks_infra.id
}

output "aks_infra_uami_principal_id" {
  description = "Principal ID of the AKS infrastructure UAMI."
  value       = azurerm_user_assigned_identity.aks_infra.principal_id
}

output "workload_uami_id" {
  description = "Resource ID of the workload UAMI."
  value       = azurerm_user_assigned_identity.workload.id
}

output "workload_uami_principal_id" {
  description = "Principal ID of the workload UAMI."
  value       = azurerm_user_assigned_identity.workload.principal_id
}

output "workload_uami_client_id" {
  description = "Client ID of the workload UAMI (for K8s ServiceAccount annotation)."
  value       = azurerm_user_assigned_identity.workload.client_id
}
