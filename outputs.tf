output "id" {
  description = "The ID of the synapse Workspace."
  value       = azurerm_synapse_workspace.this.id
}

output "endpoints" {
  description = "A list of Connectivity endpoints for this Synapse Workspace."
  value       = azurerm_synapse_workspace.this.connectivity_endpoints
}

output "sql_administrator_password" {
  description = "SQL administrator password."
  value       = !var.azuread_authentication_only ? coalesce(var.auth_sql_administrator_password, random_password.sql_password[0].result) : null
  sensitive   = true
}

output "identity" {
  description = "The Principal ID and Tenant ID for the Service Principal associated with the Managed Service Identity of this Synapse Workspace."
  value       = azurerm_synapse_workspace.this.identity
}

########## Spark Pools ##########
output "spark_pools_id" {
  description = "The Spark Pools ID."
  value = {
    for k, v in azurerm_synapse_spark_pool.this : k => v.id
  }
}

########## Linked Services ##########
output "linked_services_id" {
  description = "The Linked Services ID."
  value = {
    for k, v in azurerm_synapse_linked_service.this : k => v.id
  }
}

######### Integrated Runtimes #########
output "azure_integration_runtimes_id" {
  description = "The Azure Integration Runtimes ID."
  value = {
    for k, v in azurerm_synapse_integration_runtime_azure.this : k => v.id
  }
}

output "self_hosted_integration_runtimes_id" {
  description = "The Self Hosted Integration Runtimes ID."
  value = {
    for k, v in azurerm_synapse_integration_runtime_self_hosted.this : k => v.id
  }
}

########## SQL Pools ##########
output "sql_pools_id" {
  description = "The SQL Pools ID."
  value = {
    for k, v in azurerm_synapse_sql_pool.this : k => v.id
  }
}
