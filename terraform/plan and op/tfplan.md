➜  terraform git:(main) ✗ tf plan     

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # module.aks.azurerm_kubernetes_cluster.this will be created
  + resource "azurerm_kubernetes_cluster" "this" {
      + ai_toolchain_operator_enabled       = false
      + current_kubernetes_version          = (known after apply)
      + dns_prefix                          = "ideahub-dev"
      + fqdn                                = (known after apply)
      + http_application_routing_zone_name  = (known after apply)
      + id                                  = (known after apply)
      + kube_admin_config                   = (sensitive value)
      + kube_admin_config_raw               = (sensitive value)
      + kube_config                         = (sensitive value)
      + kube_config_raw                     = (sensitive value)
      + kubernetes_version                  = (known after apply)
      + location                            = "centralindia"
      + name                                = "ideahub-dev-aks"
      + node_os_upgrade_channel             = "NodeImage"
      + node_resource_group                 = (known after apply)
      + node_resource_group_id              = (known after apply)
      + oidc_issuer_enabled                 = true
      + oidc_issuer_url                     = (known after apply)
      + portal_fqdn                         = (known after apply)
      + private_cluster_enabled             = true
      + private_cluster_public_fqdn_enabled = false
      + private_dns_zone_id                 = (known after apply)
      + private_fqdn                        = (known after apply)
      + resource_group_name                 = "ideahub-dev-rg"
      + role_based_access_control_enabled   = true
      + run_command_enabled                 = true
      + sku_tier                            = "Free"
      + support_plan                        = "KubernetesOfficial"
      + tags                                = {
          + "environment" = "dev"
          + "managed-by"  = "terraform"
          + "owner"       = "platform-team"
          + "project"     = "ideahub"
        }
      + workload_identity_enabled           = true

      + auto_scaler_profile (known after apply)

      + bootstrap_profile (known after apply)

      + default_node_pool {
          + kubelet_disk_type           = (known after apply)
          + max_pods                    = (known after apply)
          + name                        = "system"
          + node_count                  = 1
          + node_labels                 = (known after apply)
          + orchestrator_version        = (known after apply)
          + os_disk_size_gb             = 30
          + os_disk_type                = "Managed"
          + os_sku                      = (known after apply)
          + scale_down_mode             = "Delete"
          + temporary_name_for_rotation = "tmpsystem"
          + type                        = "VirtualMachineScaleSets"
          + ultra_ssd_enabled           = false
          + vm_size                     = "Standard_D2s_v3"
          + vnet_subnet_id              = (known after apply)
          + workload_runtime            = (known after apply)
        }

      + identity {
          + identity_ids = (known after apply)
          + principal_id = (known after apply)
          + tenant_id    = (known after apply)
          + type         = "UserAssigned"
        }

      + kubelet_identity (known after apply)

      + network_profile {
          + dns_service_ip     = (known after apply)
          + ip_versions        = (known after apply)
          + load_balancer_sku  = "standard"
          + network_data_plane = "azure"
          + network_mode       = (known after apply)
          + network_plugin     = "azure"
          + network_policy     = (known after apply)
          + outbound_type      = "loadBalancer"
          + pod_cidr           = (known after apply)
          + pod_cidrs          = (known after apply)
          + service_cidr       = (known after apply)
          + service_cidrs      = (known after apply)

          + load_balancer_profile (known after apply)

          + nat_gateway_profile (known after apply)
        }

      + node_provisioning_profile {
          + default_node_pools = "Auto"
          + mode               = "Manual"
        }

      + windows_profile (known after apply)
    }

  # module.cosmosdb.azurerm_cosmosdb_account.this will be created
  + resource "azurerm_cosmosdb_account" "this" {
      + access_key_metadata_writes_enabled           = true
      + analytical_storage_enabled                   = false
      + automatic_failover_enabled                   = false
      + burst_capacity_enabled                       = false
      + create_mode                                  = (known after apply)
      + default_identity_type                        = "FirstPartyIdentity"
      + endpoint                                     = (known after apply)
      + free_tier_enabled                            = true
      + id                                           = (known after apply)
      + is_virtual_network_filter_enabled            = false
      + kind                                         = "GlobalDocumentDB"
      + local_authentication_enabled                 = true
      + location                                     = "centralindia"
      + minimal_tls_version                          = "Tls12"
      + mongo_server_version                         = (known after apply)
      + multiple_write_locations_enabled             = false
      + name                                         = "ideahub-dev-cosmos"
      + network_acl_bypass_for_azure_services        = false
      + offer_type                                   = "Standard"
      + partition_merge_enabled                      = false
      + primary_key                                  = (sensitive value)
      + primary_mongodb_connection_string            = (sensitive value)
      + primary_readonly_key                         = (sensitive value)
      + primary_readonly_mongodb_connection_string   = (sensitive value)
      + primary_readonly_sql_connection_string       = (sensitive value)
      + primary_sql_connection_string                = (sensitive value)
      + public_network_access_enabled                = true
      + read_endpoints                               = (known after apply)
      + resource_group_name                          = "ideahub-dev-rg"
      + secondary_key                                = (sensitive value)
      + secondary_mongodb_connection_string          = (sensitive value)
      + secondary_readonly_key                       = (sensitive value)
      + secondary_readonly_mongodb_connection_string = (sensitive value)
      + secondary_readonly_sql_connection_string     = (sensitive value)
      + secondary_sql_connection_string              = (sensitive value)
      + tags                                         = {
          + "environment" = "dev"
          + "managed-by"  = "terraform"
          + "owner"       = "platform-team"
          + "project"     = "ideahub"
        }
      + write_endpoints                              = (known after apply)

      + analytical_storage (known after apply)

      + backup {
          + interval_in_minutes = 1440
          + retention_in_hours  = 8
          + storage_redundancy  = "Local"
          + tier                = (known after apply)
          + type                = "Periodic"
        }

      + capabilities {
          + name = "EnableServerless"
        }

      + capacity (known after apply)

      + consistency_policy {
          + consistency_level = "Session"
        }

      + geo_location {
          + failover_priority = 0
          + id                = (known after apply)
          + location          = "centralindia"
          + zone_redundant    = false
        }
    }

  # module.cosmosdb.azurerm_cosmosdb_sql_container.this will be created
  + resource "azurerm_cosmosdb_sql_container" "this" {
      + account_name        = "ideahub-dev-cosmos"
      + database_name       = "ideahub"
      + id                  = (known after apply)
      + name                = "ideas"
      + partition_key_kind  = "Hash"
      + partition_key_paths = [
          + "/id",
        ]
      + resource_group_name = "ideahub-dev-rg"
      + throughput          = (known after apply)

      + conflict_resolution_policy (known after apply)

      + indexing_policy {
          + indexing_mode = "consistent"

          + excluded_path {
              + path = "/\"_etag\"/?"
            }

          + included_path {
              + path = "/*"
            }
        }
    }

  # module.cosmosdb.azurerm_cosmosdb_sql_database.this will be created
  + resource "azurerm_cosmosdb_sql_database" "this" {
      + account_name        = "ideahub-dev-cosmos"
      + id                  = (known after apply)
      + name                = "ideahub"
      + resource_group_name = "ideahub-dev-rg"
      + throughput          = (known after apply)
    }

  # module.cosmosdb.azurerm_cosmosdb_sql_role_assignment.workload_data_contributor will be created
  + resource "azurerm_cosmosdb_sql_role_assignment" "workload_data_contributor" {
      + account_name        = "ideahub-dev-cosmos"
      + id                  = (known after apply)
      + name                = (known after apply)
      + principal_id        = (known after apply)
      + resource_group_name = "ideahub-dev-rg"
      + role_definition_id  = (known after apply)
      + scope               = (known after apply)
    }

  # module.federation.azurerm_federated_identity_credential.workload will be created
  + resource "azurerm_federated_identity_credential" "workload" {
      + audience                  = [
          + "api://AzureADTokenExchange",
        ]
      + id                        = (known after apply)
      + issuer                    = (known after apply)
      + name                      = "ideahub-dev-federated-cred"
      + subject                   = "system:serviceaccount:ideahub:ideahub-sa"
      + user_assigned_identity_id = (known after apply)
    }

  # module.identity.azurerm_role_assignment.aks_network_contributor will be created
  + resource "azurerm_role_assignment" "aks_network_contributor" {
      + condition_version                = (known after apply)
      + id                               = (known after apply)
      + name                             = (known after apply)
      + principal_id                     = (known after apply)
      + principal_type                   = (known after apply)
      + role_definition_id               = (known after apply)
      + role_definition_name             = "Network Contributor"
      + scope                            = (known after apply)
      + skip_service_principal_aad_check = true
    }

  # module.identity.azurerm_user_assigned_identity.aks_infra will be created
  + resource "azurerm_user_assigned_identity" "aks_infra" {
      + client_id           = (known after apply)
      + id                  = (known after apply)
      + location            = "centralindia"
      + name                = "ideahub-dev-aks-infra-uami"
      + principal_id        = (known after apply)
      + resource_group_name = "ideahub-dev-rg"
      + tags                = {
          + "environment" = "dev"
          + "managed-by"  = "terraform"
          + "owner"       = "platform-team"
          + "project"     = "ideahub"
        }
      + tenant_id           = (known after apply)
    }

  # module.identity.azurerm_user_assigned_identity.workload will be created
  + resource "azurerm_user_assigned_identity" "workload" {
      + client_id           = (known after apply)
      + id                  = (known after apply)
      + location            = "centralindia"
      + name                = "ideahub-dev-aks-workload-uami"
      + principal_id        = (known after apply)
      + resource_group_name = "ideahub-dev-rg"
      + tags                = {
          + "environment" = "dev"
          + "managed-by"  = "terraform"
          + "owner"       = "platform-team"
          + "project"     = "ideahub"
        }
      + tenant_id           = (known after apply)
    }

  # module.jumpbox.azurerm_linux_virtual_machine.this will be created
  + resource "azurerm_linux_virtual_machine" "this" {
      + admin_username                                         = "jarvis"
      + allow_extension_operations                             = (known after apply)
      + bypass_platform_safety_checks_on_user_schedule_enabled = false
      + computer_name                                          = (known after apply)
      + custom_data                                            = (sensitive value)
      + disable_password_authentication                        = true
      + disk_controller_type                                   = (known after apply)
      + extensions_time_budget                                 = "PT1H30M"
      + id                                                     = (known after apply)
      + location                                               = "centralindia"
      + max_bid_price                                          = -1
      + name                                                   = "ideahub-dev-jumpbox"
      + network_interface_ids                                  = (known after apply)
      + os_managed_disk_id                                     = (known after apply)
      + patch_assessment_mode                                  = (known after apply)
      + patch_mode                                             = (known after apply)
      + platform_fault_domain                                  = -1
      + priority                                               = "Regular"
      + private_ip_address                                     = (known after apply)
      + private_ip_addresses                                   = (known after apply)
      + provision_vm_agent                                     = (known after apply)
      + public_ip_address                                      = (known after apply)
      + public_ip_addresses                                    = (known after apply)
      + resource_group_name                                    = "ideahub-dev-rg"
      + size                                                   = "Standard_B1s"
      + tags                                                   = {
          + "environment" = "dev"
          + "managed-by"  = "terraform"
          + "owner"       = "platform-team"
          + "project"     = "ideahub"
        }
      + virtual_machine_id                                     = (known after apply)
      + vm_agent_platform_updates_enabled                      = (known after apply)

      + admin_ssh_key {
          # At least one attribute in this block is (or was) sensitive,
          # so its contents will not be displayed.
        }

      + os_disk {
          + caching                   = "ReadWrite"
          + disk_size_gb              = 30
          + id                        = (known after apply)
          + name                      = (known after apply)
          + storage_account_type      = "Standard_LRS"
          + write_accelerator_enabled = false
        }

      + source_image_reference {
          + offer     = "ubuntu-24_04-lts"
          + publisher = "Canonical"
          + sku       = "server"
          + version   = "latest"
        }

      + termination_notification (known after apply)
    }

  # module.jumpbox.azurerm_network_interface.this will be created
  + resource "azurerm_network_interface" "this" {
      + accelerated_networking_enabled = false
      + applied_dns_servers            = (known after apply)
      + id                             = (known after apply)
      + internal_domain_name_suffix    = (known after apply)
      + ip_forwarding_enabled          = false
      + location                       = "centralindia"
      + mac_address                    = (known after apply)
      + name                           = "ideahub-dev-jumpbox-nic"
      + private_ip_address             = (known after apply)
      + private_ip_addresses           = (known after apply)
      + resource_group_name            = "ideahub-dev-rg"
      + tags                           = {
          + "environment" = "dev"
          + "managed-by"  = "terraform"
          + "owner"       = "platform-team"
          + "project"     = "ideahub"
        }
      + virtual_machine_id             = (known after apply)

      + ip_configuration {
          + gateway_load_balancer_frontend_ip_configuration_id = (known after apply)
          + name                                               = "internal"
          + primary                                            = (known after apply)
          + private_ip_address                                 = (known after apply)
          + private_ip_address_allocation                      = "Dynamic"
          + private_ip_address_version                         = "IPv4"
          + public_ip_address_id                               = (known after apply)
          + subnet_id                                          = (known after apply)
        }
    }

  # module.jumpbox.azurerm_public_ip.this will be created
  + resource "azurerm_public_ip" "this" {
      + allocation_method       = "Static"
      + ddos_protection_mode    = "VirtualNetworkInherited"
      + fqdn                    = (known after apply)
      + id                      = (known after apply)
      + idle_timeout_in_minutes = 4
      + ip_address              = (known after apply)
      + ip_version              = "IPv4"
      + location                = "centralindia"
      + name                    = "ideahub-dev-jumpbox-pip"
      + resource_group_name     = "ideahub-dev-rg"
      + sku                     = "Standard"
      + sku_tier                = "Regional"
      + tags                    = {
          + "environment" = "dev"
          + "managed-by"  = "terraform"
          + "owner"       = "platform-team"
          + "project"     = "ideahub"
        }
    }

  # module.networking.azurerm_network_security_group.vm will be created
  + resource "azurerm_network_security_group" "vm" {
      + id                  = (known after apply)
      + location            = "centralindia"
      + name                = "ideahub-dev-vm-nsg"
      + resource_group_name = "ideahub-dev-rg"
      + security_rule       = (known after apply)
      + tags                = {
          + "environment" = "dev"
          + "managed-by"  = "terraform"
          + "owner"       = "platform-team"
          + "project"     = "ideahub"
        }
    }

  # module.networking.azurerm_network_security_rule.ssh_inbound will be created
  + resource "azurerm_network_security_rule" "ssh_inbound" {
      + access                      = "Allow"
      + destination_address_prefix  = "*"
      + destination_port_range      = "22"
      + direction                   = "Inbound"
      + id                          = (known after apply)
      + name                        = "AllowSSH"
      + network_security_group_name = "ideahub-dev-vm-nsg"
      + priority                    = 100
      + protocol                    = "Tcp"
      + resource_group_name         = "ideahub-dev-rg"
      + source_address_prefix       = "*"
      + source_port_range           = "*"
    }

  # module.networking.azurerm_subnet.aks will be created
  + resource "azurerm_subnet" "aks" {
      + address_prefixes                              = [
          + "10.0.1.0/24",
        ]
      + default_outbound_access_enabled               = true
      + id                                            = (known after apply)
      + name                                          = "ideahub-dev-aks-subnet"
      + network_security_group_id                     = (known after apply)
      + network_security_group_id_wo                  = (write-only attribute)
      + private_endpoint_network_policies             = "Disabled"
      + private_link_service_network_policies_enabled = true
      + resource_group_name                           = "ideahub-dev-rg"
      + route_table_id                                = (known after apply)
      + route_table_id_wo                             = (write-only attribute)
      + virtual_network_name                          = "ideahub-dev-vnet"
    }

  # module.networking.azurerm_subnet.vm will be created
  + resource "azurerm_subnet" "vm" {
      + address_prefixes                              = [
          + "10.0.2.0/24",
        ]
      + default_outbound_access_enabled               = true
      + id                                            = (known after apply)
      + name                                          = "ideahub-dev-vm-subnet"
      + network_security_group_id                     = (known after apply)
      + network_security_group_id_wo                  = (write-only attribute)
      + private_endpoint_network_policies             = "Disabled"
      + private_link_service_network_policies_enabled = true
      + resource_group_name                           = "ideahub-dev-rg"
      + route_table_id                                = (known after apply)
      + route_table_id_wo                             = (write-only attribute)
      + virtual_network_name                          = "ideahub-dev-vnet"
    }

  # module.networking.azurerm_subnet_network_security_group_association.vm will be created
  + resource "azurerm_subnet_network_security_group_association" "vm" {
      + id                        = (known after apply)
      + network_security_group_id = (known after apply)
      + subnet_id                 = (known after apply)
    }

  # module.networking.azurerm_virtual_network.this will be created
  + resource "azurerm_virtual_network" "this" {
      + address_space                  = [
          + "10.0.0.0/16",
        ]
      + dns_servers                    = (known after apply)
      + guid                           = (known after apply)
      + id                             = (known after apply)
      + location                       = "centralindia"
      + name                           = "ideahub-dev-vnet"
      + private_endpoint_vnet_policies = "Disabled"
      + resource_group_name            = "ideahub-dev-rg"
      + subnet                         = (known after apply)
      + tags                           = {
          + "environment" = "dev"
          + "managed-by"  = "terraform"
          + "owner"       = "platform-team"
          + "project"     = "ideahub"
        }
    }

  # module.private_endpoint.azurerm_private_dns_zone.cosmos will be created
  + resource "azurerm_private_dns_zone" "cosmos" {
      + id                                                    = (known after apply)
      + max_number_of_record_sets                             = (known after apply)
      + max_number_of_virtual_network_links                   = (known after apply)
      + max_number_of_virtual_network_links_with_registration = (known after apply)
      + name                                                  = "privatelink.documents.azure.com"
      + number_of_record_sets                                 = (known after apply)
      + resource_group_name                                   = "ideahub-dev-rg"
      + tags                                                  = {
          + "environment" = "dev"
          + "managed-by"  = "terraform"
          + "owner"       = "platform-team"
          + "project"     = "ideahub"
        }

      + soa_record (known after apply)
    }

  # module.private_endpoint.azurerm_private_dns_zone_virtual_network_link.cosmos will be created
  + resource "azurerm_private_dns_zone_virtual_network_link" "cosmos" {
      + id                   = (known after apply)
      + name                 = "ideahub-dev-cosmos-dns-link"
      + private_dns_zone_id  = (known after apply)
      + registration_enabled = false
      + resolution_policy    = (known after apply)
      + tags                 = {
          + "environment" = "dev"
          + "managed-by"  = "terraform"
          + "owner"       = "platform-team"
          + "project"     = "ideahub"
        }
      + virtual_network_id   = (known after apply)
    }

  # module.private_endpoint.azurerm_private_endpoint.cosmos will be created
  + resource "azurerm_private_endpoint" "cosmos" {
      + custom_dns_configs       = (known after apply)
      + id                       = (known after apply)
      + location                 = "centralindia"
      + name                     = "ideahub-dev-cosmos-pe"
      + network_interface        = (known after apply)
      + private_dns_zone_configs = (known after apply)
      + resource_group_name      = "ideahub-dev-rg"
      + subnet_id                = (known after apply)
      + tags                     = {
          + "environment" = "dev"
          + "managed-by"  = "terraform"
          + "owner"       = "platform-team"
          + "project"     = "ideahub"
        }

      + private_dns_zone_group {
          + id                   = (known after apply)
          + name                 = "cosmos-dns-group"
          + private_dns_zone_ids = (known after apply)
        }

      + private_service_connection {
          + is_manual_connection           = false
          + name                           = "ideahub-dev-cosmos-psc"
          + private_connection_resource_id = (known after apply)
          + private_ip_address             = (known after apply)
          + subresource_names              = [
              + "Sql",
            ]
        }
    }

  # module.resource_group.azurerm_resource_group.this will be created
  + resource "azurerm_resource_group" "this" {
      + id       = (known after apply)
      + location = "centralindia"
      + name     = "ideahub-dev-rg"
      + tags     = {
          + "environment" = "dev"
          + "managed-by"  = "terraform"
          + "owner"       = "platform-team"
          + "project"     = "ideahub"
        }
    }

Plan: 22 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + aks_cluster_name            = "ideahub-dev-aks"
  + aks_get_credentials_command = "az aks get-credentials --resource-group ideahub-dev-rg --name ideahub-dev-aks"
  + aks_oidc_issuer_url         = (known after apply)
  + cosmosdb_container_name     = "ideas"
  + cosmosdb_database_name      = "ideahub"
  + cosmosdb_endpoint           = (known after apply)
  + cosmosdb_primary_key        = (sensitive value)
  + jumpbox_public_ip           = (known after apply)
  + jumpbox_ssh_command         = (known after apply)
  + resource_group_name         = "ideahub-dev-rg"
  + vnet_name                   = "ideahub-dev-vnet"
  + workload_uami_client_id     = (known after apply)

────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
➜  terraform git:(main) ✗ 