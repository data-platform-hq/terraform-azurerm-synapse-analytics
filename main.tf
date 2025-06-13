resource "random_password" "sql_password" {
  count            = !var.azuread_authentication_only && var.auth_sql_administrator_password == null ? 1 : 0
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_synapse_workspace" "this" {
  name                                 = var.name
  resource_group_name                  = var.resource_group_name
  managed_resource_group_name          = var.managed_resource_group_name != "" ? var.managed_resource_group_name : null
  location                             = var.location
  storage_data_lake_gen2_filesystem_id = var.storage_data_lake_gen2_filesystem_id
  sql_administrator_login              = !var.azuread_authentication_only ? coalesce(var.auth_sql_administrator, "sqladminuser") : null
  sql_administrator_login_password     = !var.azuread_authentication_only ? coalesce(var.auth_sql_administrator_password, random_password.sql_password[0].result) : null
  azuread_authentication_only          = var.azuread_authentication_only
  purview_id                           = var.purview_id
  managed_virtual_network_enabled      = var.managed_virtual_network_enabled

  dynamic "github_repo" {
    for_each = var.github != null ? [var.github] : []
    content {
      account_name    = github_repo.value.account_name
      repository_name = github_repo.value.repository_name
      branch_name     = github_repo.value.branch_name
      root_folder     = github_repo.value.root_folder
      git_url         = lookup(github_repo.value, "git_url", null)
      last_commit_id  = lookup(github_repo.value, "last_commit_id", null)
    }
  }

  dynamic "azure_devops_repo" {
    for_each = var.azure_devops_repo != null ? [var.azure_devops_repo] : []
    content {
      account_name    = azure_devops_repo.value.account_name
      project_name    = azure_devops_repo.value.project_name
      repository_name = azure_devops_repo.value.repository_name
      branch_name     = azure_devops_repo.value.branch_name
      root_folder     = azure_devops_repo.value.root_folder
      last_commit_id  = lookup(azure_devops_repo.value, "last_commit_id", null)
      tenant_id       = azure_devops_repo.value.tenant_id
    }
  }

  dynamic "identity" {
    for_each = var.identity_type != null ? [1] : []
    content {
      type         = var.identity_type
      identity_ids = var.identity_type == "UserAssigned" ? var.identity_ids : []
    }
  }

  lifecycle {
    ignore_changes = [
      github_repo[0].last_commit_id,
      azure_devops_repo[0].last_commit_id,
    sql_administrator_login]
  }

  tags = var.tags
}

############################### Access Control ###############################
# To storage account 
resource "azurerm_role_assignment" "storage_blob_contributor" {
  count                = var.add_storage_contributor_role ? length(azurerm_synapse_workspace.this.identity) : 0
  scope                = var.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_synapse_workspace.this.identity[count.index].principal_id
}

resource "azurerm_role_assignment" "this" {
  count                = length(var.azure_role_assignments)
  scope                = azurerm_synapse_workspace.this.id
  role_definition_name = var.azure_role_assignments[count.index].role_name
  principal_id         = var.azure_role_assignments[count.index].principal_id
}

resource "azurerm_synapse_role_assignment" "this" {
  count                = length(var.synapse_role_assignments)
  synapse_workspace_id = azurerm_synapse_workspace.this.id
  role_name            = var.synapse_role_assignments[count.index].role_name
  principal_id         = var.synapse_role_assignments[count.index].principal_id
  principal_type       = lookup(var.synapse_role_assignments[count.index], "principal_type", null)

  depends_on = [
    time_sleep.wait_for_firewall_operations
  ]
}

############################### Firewall Rules ###############################
resource "azurerm_synapse_firewall_rule" "this" {
  count                = length(var.firewall_rules)
  synapse_workspace_id = azurerm_synapse_workspace.this.id
  name                 = var.firewall_rules[count.index].name
  start_ip_address     = var.firewall_rules[count.index].start_ip_address
  end_ip_address       = var.firewall_rules[count.index].end_ip_address
}

resource "azurerm_synapse_firewall_rule" "azureservices" {
  count                = var.allow_azure_services_access ? 1 : 0
  synapse_workspace_id = azurerm_synapse_workspace.this.id
  name                 = "AllowAllWindowsAzureIps"
  start_ip_address     = "0.0.0.0"
  end_ip_address       = "0.0.0.0"
}

resource "azurerm_synapse_firewall_rule" "client_ip" {
  count                = var.allow_own_ip ? 1 : 0
  synapse_workspace_id = azurerm_synapse_workspace.this.id
  name                 = "ClientIp"
  start_ip_address     = chomp(data.http.client_ip[0].response_body)
  end_ip_address       = chomp(data.http.client_ip[0].response_body)
}

resource "time_sleep" "wait_for_firewall_operations" {
  count = var.allow_own_ip ? 1 : 0

  create_duration  = var.wait_for_firewall_operations.create
  destroy_duration = var.wait_for_firewall_operations.destroy

  depends_on = [
    azurerm_synapse_firewall_rule.client_ip
  ]
}

############################### Linked Services ###############################
resource "azurerm_synapse_linked_service" "this" {
  for_each              = var.linked_services
  name                  = each.key
  description           = each.value["description"]
  synapse_workspace_id  = azurerm_synapse_workspace.this.id
  type                  = each.value["type"]
  type_properties_json  = each.value["type_properties_json"]
  additional_properties = each.value["additional_properties"]
  annotations           = each.value["annotations"]
  parameters            = each.value["parameters"]
  dynamic "integration_runtime" {
    for_each = each.value["integration_runtime_name"] != null ? [1] : []
    content {
      name       = each.value["integration_runtime_name"]
      parameters = each.value["integration_runtime_parameters"]
    }
  }

  depends_on = [
    time_sleep.wait_for_firewall_operations
  ]

}

############################### Spark Pools ###############################
resource "azurerm_synapse_spark_pool" "this" {
  for_each                            = var.spark_pools
  name                                = each.key
  synapse_workspace_id                = azurerm_synapse_workspace.this.id
  node_size_family                    = each.value["node_size_family"]
  node_size                           = each.value["node_size"]
  node_count                          = each.value["node_count"]
  cache_size                          = each.value["cache_size"]
  compute_isolation_enabled           = each.value["compute_isolation_enabled"]
  dynamic_executor_allocation_enabled = each.value["dynamic_executor_allocation_enabled"]
  min_executors                       = each.value["min_executors"]
  max_executors                       = each.value["max_executors"]
  session_level_packages_enabled      = each.value["session_level_packages_enabled"]
  spark_log_folder                    = each.value["spark_log_folder"]
  spark_events_folder                 = each.value["spark_events_folder"]
  spark_version                       = each.value["spark_version"]

  dynamic "auto_scale" {
    for_each = each.value["autoscale_max_node_count"] != null ? [1] : []
    content {
      max_node_count = each.value["autoscale_max_node_count"]
      min_node_count = each.value["autoscale_min_node_count"]
    }
  }

  dynamic "auto_pause" {
    for_each = each.value["autopause_delay_in_minutes"] != null ? [1] : []
    content {
      delay_in_minutes = each.value["autopause_delay_in_minutes"]
    }
  }

  dynamic "library_requirement" {
    for_each = each.value["requirements_content"] != null ? [1] : []
    content {
      content  = each.value["requirements_content"]
      filename = each.value["requirements_filename"]
    }
  }

  dynamic "spark_config" {
    for_each = each.value["spark_config_content"] != null ? [1] : []
    content {
      content  = each.value["spark_config_content"]
      filename = each.value["spark_config_filename"]
    }
  }

  tags = var.tags

  depends_on = [
    azurerm_synapse_firewall_rule.this,
    azurerm_synapse_firewall_rule.azureservices,
    azurerm_synapse_firewall_rule.client_ip,
  ]
}

############################### Integration Runtimes ###############################
resource "azurerm_synapse_integration_runtime_azure" "this" {
  for_each             = var.azure_integration_runtimes
  name                 = each.key
  synapse_workspace_id = azurerm_synapse_workspace.this.id
  description          = each.value["description"]
  location             = each.value["location"]
  compute_type         = each.value["compute_type"]
  core_count           = each.value["core_count"]
  time_to_live_min     = each.value["time_to_live_min"]
}

resource "azurerm_synapse_integration_runtime_self_hosted" "this" {
  for_each             = var.self_hosted_integration_runtimes
  name                 = each.key
  synapse_workspace_id = azurerm_synapse_workspace.this.id
  description          = each.value["description"]
}

############################## SQL Pools ###############################
resource "azurerm_synapse_sql_pool" "this" {
  for_each                  = var.sql_pools
  name                      = each.key
  synapse_workspace_id      = azurerm_synapse_workspace.this.id
  sku_name                  = each.value["sku_name"]
  create_mode               = each.value["create_mode"]
  collation                 = each.value["collation"]
  data_encrypted            = each.value["data_encrypted"]
  recovery_database_id      = each.value["recovery_database_id"]
  geo_backup_policy_enabled = each.value["geo_backup_policy_enabled"]
  storage_account_type      = each.value["storage_account_type"]
  dynamic "restore" {
    for_each = each.value["restore_source_database_id"] != null ? [1] : []
    content {
      source_database_id = each.value["restore_source_database_id"]
      point_in_time      = each.value["restore_point_in_time"]
    }
  }
  tags = var.tags
}
