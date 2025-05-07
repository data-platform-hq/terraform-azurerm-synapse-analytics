variable "name" {
  description = "Specifies the name which should be used for this synapse Workspace. Changing this forces a new resource to be created."
  type        = string
}

variable "resource_group_name" {
  description = "Specifies the name of the Resource Group where the synapse Workspace should exist. Changing this forces a new resource to be created."
  type        = string
}

variable "managed_resource_group_name" {
  description = "Specifies the name of the Managed Resource Group for the synapse Workspace. Changing this forces a new resource to be created."
  type        = string
  default     = ""
}

variable "location" {
  description = "Specifies the Azure Region where the synapse Workspace should exist. Changing this forces a new resource to be created."
  type        = string
}

variable "storage_data_lake_gen2_filesystem_id" {
  description = "Specifies the ID of storage data lake gen2 filesystem resource. Changing this forces a new resource to be created."
  type        = string
}

variable "azuread_authentication_only" {
  description = "Azure Active Directory Authentication the only way to authenticate with resources inside this synapse Workspace."
  type        = bool
  default     = false
}

variable "auth_sql_administrator" {
  description = "Specifies The login name of the SQL administrator. Changing this forces a new resource to be created."
  type        = string
  default     = null
}

variable "auth_sql_administrator_password" {
  description = "The Password associated with the sql_administrator_login for the SQL administrator."
  type        = string
  default     = null
  sensitive   = true
}

variable "tags" {
  description = "A mapping of tags which should be assigned to the Synapse Workspace."
  type        = map(string)
  default     = null
}

variable "purview_id" {
  description = "The ID of purview account."
  type        = string
  default     = null
}

variable "identity_type" {
  description = "Specifies the type of Managed Service Identity that should be associated with this Logic App."
  type        = string
  default     = "SystemAssigned"
  validation {
    error_message = "Please use a valid source!"
    condition     = var.identity_type == null || can(contains(["SystemAssigned", "UserAssigned"], var.identity_type))
  }
}

variable "identity_ids" {
  description = "Specifies a list of User Assigned Managed Identity IDs to be assigned to this Synapse Workspace."
  type        = list(string)
  default     = []
}

######### Firewall Rules #########
variable "firewall_rules" {
  description = "Allows you to Manages a Synapse Firewall Rules."
  type = list(object({
    name             = string
    start_ip_address = string
    end_ip_address   = string
  }))
  default = []
}

variable "allow_azure_services_access" {
  description = "If true, allow Azure Services and Resources to access this workspace."
  type        = bool
  default     = false
}

variable "allow_own_ip" {
  description = "If true, create firewall rule to allow client IP to Synapse Workspace."
  type        = bool
  default     = false
}

variable "wait_for_firewall_operations" {
  description = "Timeout settings for firewall operations."
  type = object({
    create  = optional(string, "30s")
    destroy = optional(string, "0s")
  })
  default = {
    create  = "30s"
    destroy = "0s"
  }
}

######### Github #########
variable "github" {
  description = "Integrate Synapse Workspace with Github."
  type = object({
    account_name    = string
    repository_name = string
    branch_name     = string
    root_folder     = string
    last_commit_id  = optional(string)
    git_url         = optional(string)
  })
  default = null
}

######### Azure DevOps #########
variable "azure_devops_repo" {
  description = "Integrate Synapse Workspace with Azure DevOps."
  type = object({
    account_name    = string
    project_name    = string
    repository_name = string
    branch_name     = string
    root_folder     = string
    last_commit_id  = optional(string)
    tenant_id       = optional(string)
  })
  default = null
}


######### Access Control #########
variable "add_storage_contributor_role" {
  description = "If true, add Storage Contributor Role to Synapse Workspace identity."
  type        = bool
  default     = true
}

variable "storage_account_id" {
  description = "Storage Account ID used by Synapse Workspace. Necessary if `add_storage_contributor_role` is true."
  type        = string
  default     = false
}

variable "synapse_role_assignments" {
  description = "Manages a Synapse Role Assignment."
  type = list(object({
    role_name      = string
    principal_id   = string
    principal_type = optional(string, null)
  }))
  default = []
}

variable "azure_role_assignments" {
  description = "Manages a Azure Role Assignment to Synapse Workspace."
  type = list(object({
    role_name    = string
    principal_id = string
  }))
  default = []
}

######### Spark Pools #########
variable "spark_pools" {
  description = "Manages a Synapse Spark Pools."
  type = map(object({
    node_size_family                    = optional(string, "None")
    node_size                           = optional(string, "Small")
    node_count                          = optional(number, null)
    cache_size                          = optional(number, null)
    compute_isolation_enabled           = optional(bool, false)
    dynamic_executor_allocation_enabled = optional(bool, false)
    min_executors                       = optional(number, null)
    max_executors                       = optional(number, null)
    session_level_packages_enabled      = optional(bool, false)
    spark_log_folder                    = optional(string, "/logs")
    spark_events_folder                 = optional(string, "/events")
    spark_version                       = optional(string, "3.4")
    autoscale_max_node_count            = optional(number, null)
    autoscale_min_node_count            = optional(number, null)
    autopause_delay_in_minutes          = optional(number, null)
    requirements_content                = optional(string, null)
    requirements_filename               = optional(string, "requirements.txt")
    spark_config_content                = optional(string, null)
    spark_config_filename               = optional(string, "config.txt")
  }))
  default = {}
}

######### Linked Services #########
variable "linked_services" {
  description = "Manages a Synapse Linked Services."
  type = map(object({
    type                           = string
    type_properties_json           = string
    additional_properties          = optional(map(string), {})
    annotations                    = optional(list(string), [])
    description                    = optional(string, null)
    parameters                     = optional(map(string), {})
    integration_runtime_name       = optional(string, null)
    integration_runtime_parameters = optional(map(string), {})
  }))
  default = {}
}

######### Integration Runtimes #########
variable "azure_integration_runtimes" {
  description = "Manages a Azure Synapse Azure Integration Runtimes."
  type = map(object({
    location         = optional(string, "AutoResolve")
    compute_type     = optional(string, "General")
    core_count       = optional(number, 8)
    description      = optional(string, null)
    time_to_live_min = optional(number, 0)
  }))
  default = {}
}

variable "self_hosted_integration_runtimes" {
  description = "Manages a Self Hosted Synapse Azure Integration Runtimes."
  type = map(object({
    description = optional(string, null)
  }))
  default = {}
}

variable "managed_virtual_network_enabled" {
  description = "Identifyes if Virtual Network is enabled for all computes in this workspace"
  type        = bool
  default     = false
}

######### SQL Pools #########
variable "sql_pools" {
  description = "Manages a Synapse SQL Pools."
  type = map(object({
    sku_name                   = string
    create_mode                = optional(string, "Default")
    collation                  = optional(string, "SQL_LATIN1_GENERAL_CP1_CI_AS")
    data_encrypted             = optional(bool, false)
    recovery_database_id       = optional(string, null)
    geo_backup_policy_enabled  = optional(bool, true)
    storage_account_type       = optional(string, "GRS")
    restore_source_database_id = optional(string, null)
    restore_point_in_time      = optional(string, false)

  }))
  default = {}
}

######### Networok Integration #########
variable "private_link_hub_name" {
  description = "Name of the Private Link Hub"
  type        = string
  default     = null
}

variable "private_endpoints" {
  type = map(object({
    name = optional(string, null)
    role_assignments = optional(map(object({
      role_definition_id_or_name             = string
      principal_id                           = string
      description                            = optional(string, null)
      skip_service_principal_aad_check       = optional(bool, false)
      condition                              = optional(string, null)
      condition_version                      = optional(string, null)
      delegated_managed_identity_resource_id = optional(string, null)
      principal_type                         = optional(string, null)
    })), {})
    lock = optional(object({
      kind = string
      name = optional(string, null)
    }), null)
    tags                                    = optional(map(string), null)
    subnet_resource_id                      = string
    subresource_name                        = string
    private_dns_zone_group_name             = optional(string, "default")
    private_dns_zone_resource_ids           = optional(set(string), [])
    application_security_group_associations = optional(map(string), {})
    private_service_connection_name         = optional(string, null)
    network_interface_name                  = optional(string, null)
    location                                = optional(string, null)
    resource_group_name                     = optional(string, null)
    ip_configurations = optional(map(object({
      name               = string
      private_ip_address = string
    })), {})
  }))
  default     = {}
  description = <<DESCRIPTION
A map of private endpoints to create on the resource. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `name` - (Optional) The name of the private endpoint. One will be generated if not set.
- `role_assignments` - (Optional) A map of role assignments to create on the private endpoint. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time. See `var.role_assignments` for more information.
- `lock` - (Optional) The lock level to apply to the private endpoint. Default is `None`. Possible values are `None`, `CanNotDelete`, and `ReadOnly`.
- `tags` - (Optional) A mapping of tags to assign to the private endpoint.
- `subnet_resource_id` - The resource ID of the subnet to deploy the private endpoint in.
- `subresource_name` - The service name of the private endpoint.  Possible value are `blob`, 'dfs', 'file', `queue`, `table`, and `web`.
- `private_dns_zone_group_name` - (Optional) The name of the private DNS zone group. One will be generated if not set.
- `private_dns_zone_resource_ids` - (Optional) A set of resource IDs of private DNS zones to associate with the private endpoint. If not set, no zone groups will be created and the private endpoint will not be associated with any private DNS zones. DNS records must be managed external to this module.
- `application_security_group_resource_ids` - (Optional) A map of resource IDs of application security groups to associate with the private endpoint. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.
- `private_service_connection_name` - (Optional) The name of the private service connection. One will be generated if not set.
- `network_interface_name` - (Optional) The name of the network interface. One will be generated if not set.
- `location` - (Optional) The Azure location where the resources will be deployed. Defaults to the location of the resource group.
- `resource_group_name` - (Optional) The resource group where the resources will be deployed. Defaults to the resource group of the resource.
- `ip_configurations` - (Optional) A map of IP configurations to create on the private endpoint. If not specified the platform will create one. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.
  - `name` - The name of the IP configuration.
  - `private_ip_address` - The private IP address of the IP configuration.
DESCRIPTION
  nullable    = false
}

variable "private_endpoints_manage_dns_zone_group" {
  type        = bool
  default     = true
  description = "Whether to manage private DNS zone groups with this module. If set to false, you must manage private DNS zone groups externally, e.g. using Azure Policy."
  nullable    = false
}

variable "private_links" {
  type = map(object({
    name               = optional(string, null)
    target_resource_id = string
    subresource_name   = optional(string, "web")
  }))
  default     = {}
  description = <<DESCRIPTION
A map of private endpoints to create on the resource. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `name` - (Optional) The name of the private link. One will be generated if not set.
- `target_resource_id` - The resource ID of the target resource to be establish private link.
- `subresource_name` - The service name of the private endpoint.  Possible value are `blob`, 'dfs', 'file', `queue`, `table`, `web`, `vault`, etc.
DESCRIPTION
  nullable    = false
}
