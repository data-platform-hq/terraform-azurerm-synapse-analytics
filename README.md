# Azure Synapse Analytics Terraform module
Terraform module for creation Azure Synapse Analytics

## Usage

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 4.0.1 |
| <a name="requirement_http"></a> [http](#requirement\_http) | >= 3.4 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.5.1 |
| <a name="requirement_time"></a> [time](#requirement\_time) | ~> 0.9.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 4.0.1 |
| <a name="provider_http"></a> [http](#provider\_http) | >= 3.4 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.5.1 |
| <a name="provider_time"></a> [time](#provider\_time) | ~> 0.9.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_private_endpoint.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.this_unmanaged_dns_zone_groups](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint_application_security_group_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint_application_security_group_association) | resource |
| [azurerm_role_assignment.private_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.storage_blob_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_synapse_firewall_rule.azureservices](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/synapse_firewall_rule) | resource |
| [azurerm_synapse_firewall_rule.client_ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/synapse_firewall_rule) | resource |
| [azurerm_synapse_firewall_rule.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/synapse_firewall_rule) | resource |
| [azurerm_synapse_integration_runtime_azure.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/synapse_integration_runtime_azure) | resource |
| [azurerm_synapse_integration_runtime_self_hosted.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/synapse_integration_runtime_self_hosted) | resource |
| [azurerm_synapse_linked_service.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/synapse_linked_service) | resource |
| [azurerm_synapse_managed_private_endpoint.private_link](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/synapse_managed_private_endpoint) | resource |
| [azurerm_synapse_private_link_hub.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/synapse_private_link_hub) | resource |
| [azurerm_synapse_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/synapse_role_assignment) | resource |
| [azurerm_synapse_spark_pool.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/synapse_spark_pool) | resource |
| [azurerm_synapse_sql_pool.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/synapse_sql_pool) | resource |
| [azurerm_synapse_workspace.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/synapse_workspace) | resource |
| [random_password.sql_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [time_sleep.wait_for_firewall_operations](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [http_http.client_ip](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_add_storage_contributor_role"></a> [add\_storage\_contributor\_role](#input\_add\_storage\_contributor\_role) | If true, add Storage Contributor Role to Synapse Workspace identity. | `bool` | `true` | no |
| <a name="input_allow_azure_services_access"></a> [allow\_azure\_services\_access](#input\_allow\_azure\_services\_access) | If true, allow Azure Services and Resources to access this workspace. | `bool` | `false` | no |
| <a name="input_allow_own_ip"></a> [allow\_own\_ip](#input\_allow\_own\_ip) | If true, create firewall rule to allow client IP to Synapse Workspace. | `bool` | `false` | no |
| <a name="input_auth_sql_administrator"></a> [auth\_sql\_administrator](#input\_auth\_sql\_administrator) | Specifies The login name of the SQL administrator. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_auth_sql_administrator_password"></a> [auth\_sql\_administrator\_password](#input\_auth\_sql\_administrator\_password) | The Password associated with the sql\_administrator\_login for the SQL administrator. | `string` | `null` | no |
| <a name="input_azure_devops_repo"></a> [azure\_devops\_repo](#input\_azure\_devops\_repo) | Integrate Synapse Workspace with Azure DevOps. | <pre>object({<br/>    account_name    = string<br/>    project_name    = string<br/>    repository_name = string<br/>    branch_name     = string<br/>    root_folder     = string<br/>    last_commit_id  = optional(string)<br/>    tenant_id       = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_azure_integration_runtimes"></a> [azure\_integration\_runtimes](#input\_azure\_integration\_runtimes) | Manages a Azure Synapse Azure Integration Runtimes. | <pre>map(object({<br/>    location         = optional(string, "AutoResolve")<br/>    compute_type     = optional(string, "General")<br/>    core_count       = optional(number, 8)<br/>    description      = optional(string, null)<br/>    time_to_live_min = optional(number, 0)<br/>  }))</pre> | `{}` | no |
| <a name="input_azure_role_assignments"></a> [azure\_role\_assignments](#input\_azure\_role\_assignments) | Manages a Azure Role Assignment to Synapse Workspace. | <pre>list(object({<br/>    role_name    = string<br/>    principal_id = string<br/>  }))</pre> | `[]` | no |
| <a name="input_azuread_authentication_only"></a> [azuread\_authentication\_only](#input\_azuread\_authentication\_only) | Azure Active Directory Authentication the only way to authenticate with resources inside this synapse Workspace. | `bool` | `false` | no |
| <a name="input_firewall_rules"></a> [firewall\_rules](#input\_firewall\_rules) | Allows you to Manages a Synapse Firewall Rules. | <pre>list(object({<br/>    name             = string<br/>    start_ip_address = string<br/>    end_ip_address   = string<br/>  }))</pre> | `[]` | no |
| <a name="input_github"></a> [github](#input\_github) | Integrate Synapse Workspace with Github. | <pre>object({<br/>    account_name    = string<br/>    repository_name = string<br/>    branch_name     = string<br/>    root_folder     = string<br/>    last_commit_id  = optional(string)<br/>    git_url         = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_identity_ids"></a> [identity\_ids](#input\_identity\_ids) | Specifies a list of User Assigned Managed Identity IDs to be assigned to this Synapse Workspace. | `list(string)` | `[]` | no |
| <a name="input_identity_type"></a> [identity\_type](#input\_identity\_type) | Specifies the type of Managed Service Identity that should be associated with this Logic App. | `string` | `"SystemAssigned"` | no |
| <a name="input_linked_services"></a> [linked\_services](#input\_linked\_services) | Manages a Synapse Linked Services. | <pre>map(object({<br/>    type                           = string<br/>    type_properties_json           = string<br/>    additional_properties          = optional(map(string), {})<br/>    annotations                    = optional(list(string), [])<br/>    description                    = optional(string, null)<br/>    parameters                     = optional(map(string), {})<br/>    integration_runtime_name       = optional(string, null)<br/>    integration_runtime_parameters = optional(map(string), {})<br/>  }))</pre> | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | Specifies the Azure Region where the synapse Workspace should exist. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_managed_resource_group_name"></a> [managed\_resource\_group\_name](#input\_managed\_resource\_group\_name) | Specifies the name of the Managed Resource Group for the synapse Workspace. Changing this forces a new resource to be created. | `string` | `""` | no |
| <a name="input_managed_virtual_network_enabled"></a> [managed\_virtual\_network\_enabled](#input\_managed\_virtual\_network\_enabled) | Identifyes if Virtual Network is enabled for all computes in this workspace | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Specifies the name which should be used for this synapse Workspace. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_private_endpoints"></a> [private\_endpoints](#input\_private\_endpoints) | A map of private endpoints to create on the resource. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.<br/><br/>- `name` - (Optional) The name of the private endpoint. One will be generated if not set.<br/>- `role_assignments` - (Optional) A map of role assignments to create on the private endpoint. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time. See `var.role_assignments` for more information.<br/>- `lock` - (Optional) The lock level to apply to the private endpoint. Default is `None`. Possible values are `None`, `CanNotDelete`, and `ReadOnly`.<br/>- `tags` - (Optional) A mapping of tags to assign to the private endpoint.<br/>- `subnet_resource_id` - The resource ID of the subnet to deploy the private endpoint in.<br/>- `subresource_name` - The service name of the private endpoint.  Possible value are `blob`, 'dfs', 'file', `queue`, `table`, and `web`.<br/>- `private_dns_zone_group_name` - (Optional) The name of the private DNS zone group. One will be generated if not set.<br/>- `private_dns_zone_resource_ids` - (Optional) A set of resource IDs of private DNS zones to associate with the private endpoint. If not set, no zone groups will be created and the private endpoint will not be associated with any private DNS zones. DNS records must be managed external to this module.<br/>- `application_security_group_resource_ids` - (Optional) A map of resource IDs of application security groups to associate with the private endpoint. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.<br/>- `private_service_connection_name` - (Optional) The name of the private service connection. One will be generated if not set.<br/>- `network_interface_name` - (Optional) The name of the network interface. One will be generated if not set.<br/>- `location` - (Optional) The Azure location where the resources will be deployed. Defaults to the location of the resource group.<br/>- `resource_group_name` - (Optional) The resource group where the resources will be deployed. Defaults to the resource group of the resource.<br/>- `ip_configurations` - (Optional) A map of IP configurations to create on the private endpoint. If not specified the platform will create one. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.<br/>  - `name` - The name of the IP configuration.<br/>  - `private_ip_address` - The private IP address of the IP configuration. | <pre>map(object({<br/>    name = optional(string, null)<br/>    role_assignments = optional(map(object({<br/>      role_definition_id_or_name             = string<br/>      principal_id                           = string<br/>      description                            = optional(string, null)<br/>      skip_service_principal_aad_check       = optional(bool, false)<br/>      condition                              = optional(string, null)<br/>      condition_version                      = optional(string, null)<br/>      delegated_managed_identity_resource_id = optional(string, null)<br/>      principal_type                         = optional(string, null)<br/>    })), {})<br/>    lock = optional(object({<br/>      kind = string<br/>      name = optional(string, null)<br/>    }), null)<br/>    tags                                    = optional(map(string), null)<br/>    subnet_resource_id                      = string<br/>    subresource_name                        = string<br/>    private_dns_zone_group_name             = optional(string, "default")<br/>    private_dns_zone_resource_ids           = optional(set(string), [])<br/>    application_security_group_associations = optional(map(string), {})<br/>    private_service_connection_name         = optional(string, null)<br/>    network_interface_name                  = optional(string, null)<br/>    location                                = optional(string, null)<br/>    resource_group_name                     = optional(string, null)<br/>    ip_configurations = optional(map(object({<br/>      name               = string<br/>      private_ip_address = string<br/>    })), {})<br/>  }))</pre> | `{}` | no |
| <a name="input_private_endpoints_manage_dns_zone_group"></a> [private\_endpoints\_manage\_dns\_zone\_group](#input\_private\_endpoints\_manage\_dns\_zone\_group) | Whether to manage private DNS zone groups with this module. If set to false, you must manage private DNS zone groups externally, e.g. using Azure Policy. | `bool` | `true` | no |
| <a name="input_private_link_hub_name"></a> [private\_link\_hub\_name](#input\_private\_link\_hub\_name) | Name of the Private Link Hub | `string` | `null` | no |
| <a name="input_private_links"></a> [private\_links](#input\_private\_links) | A map of private endpoints to create on the resource. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.<br/><br/>- `name` - (Optional) The name of the private link. One will be generated if not set.<br/>- `target_resource_id` - The resource ID of the target resource to be establish private link.<br/>- `subresource_name` - The service name of the private endpoint.  Possible value are `blob`, 'dfs', 'file', `queue`, `table`, `web`, `vault`, etc. | <pre>map(object({<br/>    name               = optional(string, null)<br/>    target_resource_id = string<br/>    subresource_name   = optional(string, "web")<br/>  }))</pre> | `{}` | no |
| <a name="input_purview_id"></a> [purview\_id](#input\_purview\_id) | The ID of purview account. | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Specifies the name of the Resource Group where the synapse Workspace should exist. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_self_hosted_integration_runtimes"></a> [self\_hosted\_integration\_runtimes](#input\_self\_hosted\_integration\_runtimes) | Manages a Self Hosted Synapse Azure Integration Runtimes. | <pre>map(object({<br/>    description = optional(string, null)<br/>  }))</pre> | `{}` | no |
| <a name="input_spark_pools"></a> [spark\_pools](#input\_spark\_pools) | Manages a Synapse Spark Pools. | <pre>map(object({<br/>    node_size_family                    = optional(string, "None")<br/>    node_size                           = optional(string, "Small")<br/>    node_count                          = optional(number, null)<br/>    cache_size                          = optional(number, null)<br/>    compute_isolation_enabled           = optional(bool, false)<br/>    dynamic_executor_allocation_enabled = optional(bool, false)<br/>    min_executors                       = optional(number, null)<br/>    max_executors                       = optional(number, null)<br/>    session_level_packages_enabled      = optional(bool, false)<br/>    spark_log_folder                    = optional(string, "/logs")<br/>    spark_events_folder                 = optional(string, "/events")<br/>    spark_version                       = optional(string, "3.4")<br/>    autoscale_max_node_count            = optional(number, null)<br/>    autoscale_min_node_count            = optional(number, null)<br/>    autopause_delay_in_minutes          = optional(number, null)<br/>    requirements_content                = optional(string, null)<br/>    requirements_filename               = optional(string, "requirements.txt")<br/>    spark_config_content                = optional(string, null)<br/>    spark_config_filename               = optional(string, "config.txt")<br/>  }))</pre> | `{}` | no |
| <a name="input_sql_pools"></a> [sql\_pools](#input\_sql\_pools) | Manages a Synapse SQL Pools. | <pre>map(object({<br/>    sku_name                   = string<br/>    create_mode                = optional(string, "Default")<br/>    collation                  = optional(string, "SQL_LATIN1_GENERAL_CP1_CI_AS")<br/>    data_encrypted             = optional(bool, false)<br/>    recovery_database_id       = optional(string, null)<br/>    geo_backup_policy_enabled  = optional(bool, true)<br/>    storage_account_type       = optional(string, "GRS")<br/>    restore_source_database_id = optional(string, null)<br/>    restore_point_in_time      = optional(string, false)<br/><br/>  }))</pre> | `{}` | no |
| <a name="input_storage_account_id"></a> [storage\_account\_id](#input\_storage\_account\_id) | Storage Account ID used by Synapse Workspace. Necessary if `add_storage_contributor_role` is true. | `string` | `false` | no |
| <a name="input_storage_data_lake_gen2_filesystem_id"></a> [storage\_data\_lake\_gen2\_filesystem\_id](#input\_storage\_data\_lake\_gen2\_filesystem\_id) | Specifies the ID of storage data lake gen2 filesystem resource. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_synapse_role_assignments"></a> [synapse\_role\_assignments](#input\_synapse\_role\_assignments) | Manages a Synapse Role Assignment. | <pre>list(object({<br/>    role_name      = string<br/>    principal_id   = string<br/>    principal_type = optional(string, null)<br/>  }))</pre> | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags which should be assigned to the Synapse Workspace. | `map(string)` | `null` | no |
| <a name="input_wait_for_firewall_operations"></a> [wait\_for\_firewall\_operations](#input\_wait\_for\_firewall\_operations) | Timeout settings for firewall operations. | <pre>object({<br/>    create  = optional(string, "30s")<br/>    destroy = optional(string, "0s")<br/>  })</pre> | <pre>{<br/>  "create": "30s",<br/>  "destroy": "0s"<br/>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_azure_integration_runtimes_id"></a> [azure\_integration\_runtimes\_id](#output\_azure\_integration\_runtimes\_id) | The Azure Integration Runtimes ID. |
| <a name="output_endpoints"></a> [endpoints](#output\_endpoints) | A list of Connectivity endpoints for this Synapse Workspace. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the synapse Workspace. |
| <a name="output_identity"></a> [identity](#output\_identity) | The Principal ID and Tenant ID for the Service Principal associated with the Managed Service Identity of this Synapse Workspace. |
| <a name="output_linked_services_id"></a> [linked\_services\_id](#output\_linked\_services\_id) | The Linked Services ID. |
| <a name="output_self_hosted_integration_runtimes_id"></a> [self\_hosted\_integration\_runtimes\_id](#output\_self\_hosted\_integration\_runtimes\_id) | The Self Hosted Integration Runtimes ID. |
| <a name="output_spark_pools_id"></a> [spark\_pools\_id](#output\_spark\_pools\_id) | The Spark Pools ID. |
| <a name="output_sql_administrator_password"></a> [sql\_administrator\_password](#output\_sql\_administrator\_password) | SQL administrator password. |
| <a name="output_sql_pools_id"></a> [sql\_pools\_id](#output\_sql\_pools\_id) | The SQL Pools ID. |
<!-- END_TF_DOCS -->

## License

Apache 2 Licensed. For more information please see [LICENSE](./LICENSE)
