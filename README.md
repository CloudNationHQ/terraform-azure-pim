# Privileged Identity Management

 This terraform module simplifies the process of managing Azure privileged identity management resources, providing customizable options for management policy, eligible and active role assignments, all managed through code.

## Features

Capability to handle both eligible as active PIM role assignments.

Support for management policy on a scope for a certain role.

Lookup definition id's of custom and / or built-in RBAC-roles. 

Lookup of Azure AD (Entra ID) groups and users (approvers and PIM member users).

Utilization of terratest for robust validation.

<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.0)

- <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) (~> 3.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 4.0)

## Providers

The following providers are used by this module:

- <a name="provider_azuread"></a> [azuread](#provider\_azuread) (~> 3.0)

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 4.0)

- <a name="provider_time"></a> [time](#provider\_time)

## Resources

The following resources are used by this module:

- [azurerm_pim_active_role_assignment.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/pim_active_role_assignment) (resource)
- [azurerm_pim_eligible_role_assignment.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/pim_eligible_role_assignment) (resource)
- [azurerm_role_management_policy.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_management_policy) (resource)
- [time_static.start_date_time](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/static) (resource)
- [azuread_group.approver](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) (data source)
- [azuread_group.main](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) (data source)
- [azuread_user.approver](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/user) (data source)
- [azuread_user.main](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/user) (data source)
- [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) (data source)
- [azurerm_role_definition.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/role_definition) (data source)

## Required Inputs

No required inputs.

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_management_policies"></a> [management\_policies](#input\_management\_policies)

Description: Map of 1 or more management policies

Type:

```hcl
map(object({
    roles = map(object({
      scopes = list(string) # List of scopes, can be subscriptions, resource groups, management groups
    }))
    active_assignment_rules = optional(object({
      expiration_required                = optional(bool)
      expire_after                       = optional(string) ## P15D, P30D, P90D, P180D, P365D
      require_justification              = optional(bool)
      require_ticket_info                = optional(bool)
      require_multifactor_authentication = optional(bool)
    }))
    eligible_assignment_rules = optional(object({
      expiration_required = optional(bool)
      expire_after        = optional(string) ## P15D, P30D, P90D, P180D, P365D
    }))
    activation_rules = optional(object({
      require_justification                              = optional(bool)
      require_ticket_info                                = optional(bool)
      require_multifactor_authentication                 = optional(bool)
      required_conditional_access_authentication_context = optional(bool)
      require_approvals                                  = optional(bool)
      maximum_duration                                   = optional(string)
      approval_stage = optional(object({
        primary_approver = map(object({
          type                = string           # "User" or "Group"
          user_principal_name = optional(string) # In case type is "User"
          mail_nickname       = optional(string) # In case type is "User"
          display_name        = optional(string) # In case type is "Group"
          object_id           = optional(string) # Object ID can be used instead of upn or display_name
        }))
      }))
    }))
    notification_rules = optional(object({
      active_assignments = optional(object({
        admin_notifications = optional(object({
          additional_recipients = optional(list(string))
          default_recipients    = optional(bool, true)
          notification_level    = string # "All" or "Critical"
        }))
        approver_notifications = optional(object({
          additional_recipients = optional(list(string))
          default_recipients    = optional(bool, true)
          notification_level    = string # "All" or "Critical"
        }))
        assignee_notifications = optional(object({
          additional_recipients = optional(list(string))
          default_recipients    = optional(bool, true)
          notification_level    = string # "All" or "Critical"
        }))
      }))
      eligible_assignments = optional(object({
        admin_notifications = optional(object({
          additional_recipients = optional(list(string))
          default_recipients    = optional(bool, true)
          notification_level    = string # "All" or "Critical"
        }))
        approver_notifications = optional(object({
          additional_recipients = optional(list(string))
          default_recipients    = optional(bool, true)
          notification_level    = string # "All" or "Critical"
        }))
        assignee_notifications = optional(object({
          additional_recipients = optional(list(string))
          default_recipients    = optional(bool, true)
          notification_level    = string # "All" or "Critical"
        }))
      }))
      eligible_activations = optional(object({
        admin_notifications = optional(object({
          additional_recipients = optional(list(string))
          default_recipients    = optional(bool, true)
          notification_level    = string # "All" or "Critical"
        }))
        approver_notifications = optional(object({
          additional_recipients = optional(list(string))
          default_recipients    = optional(bool, true)
          notification_level    = string # "All" or "Critical"
        }))
        assignee_notifications = optional(object({
          additional_recipients = optional(list(string))
          default_recipients    = optional(bool, true)
          notification_level    = string # "All" or "Critical"
        }))
      }))
    }))
  }))
```

Default: `{}`

### <a name="input_pim_assignments"></a> [pim\_assignments](#input\_pim\_assignments)

Description: Map of 1 or more PIM assignment(s)

Type:

```hcl
map(object({
    object_id           = optional(string)             # Use Object ID for User or Group instead of user_principal_name or display_name
    assignment_type     = optional(string, "Eligible") # "Eligible" or "Active"
    user_principal_name = optional(string)             # Required if type is "User" and object_id or mail_nickname is not provided
    mail_nickname       = optional(string)             # Required if type is "User" and object_id or user_principal_name is not provided
    display_name        = optional(string)             # Required if type is "Group" and object_id is not provided
    type                = string                       # "User" or "Group"
    roles = map(object({
      scopes = list(string) # List of scopes, can be subscriptions, resource groups, management groups
    }))
    justification     = optional(string, "No justification provided")
    condition         = optional(string, null)
    condition_version = optional(number, 2.0) # Only supported value is 2.0, required if condition is set
    schedule = optional(object({
      start_date_time = optional(string)
      expiration = optional(object({
        duration_days  = optional(number)
        duration_hours = optional(number)
        end_date_time  = optional(string)
      }))
    }), null)
    ticket = optional(object({
      number = optional(string)
      system = optional(string)
    }))
  }))
```

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_pim_active_role_assignments"></a> [pim\_active\_role\_assignments](#output\_pim\_active\_role\_assignments)

Description: contains all pim active role assignments

### <a name="output_pim_eligible_role_assignments"></a> [pim\_eligible\_role\_assignments](#output\_pim\_eligible\_role\_assignments)

Description: contains all pim eligible role assignments

### <a name="output_pim_role_management_policies"></a> [pim\_role\_management\_policies](#output\_pim\_role\_management\_policies)

Description: contains all pim role management policies
<!-- END_TF_DOCS -->

## Goals

For more information, please see our [goals and non-goals](./GOALS.md).

## Testing

For more information, please see our testing [guidelines](./TESTING.md)

## Notes

This module makes use of the AzureRM provider and is part of the PIM implementation for [Azure resources and roles](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-deployment-plan#what-can-you-manage-in-pim). 

For PIM for Entra ID groups, please make use of our [azuread (entra id) module](https://github.com/CloudNationHQ/terraform-azuread-pim) instead. PIM for Entra ID roles, is not yet supported natively through Terraform. 

Full examples detailing most usages, along with integrations with dependency modules, are located in the examples directory.

To update the module's documentation run `make doc`

## Authors

Module is maintained by [these awesome contributors](https://github.com/cloudnationhq/terraform-azure-pim/graphs/contributors).

## Contributors

We welcome contributions from the community! Whether it's reporting a bug, suggesting a new feature, or submitting a pull request, your input is highly valued.

For more information, please see our contribution [guidelines](./CONTRIBUTING.md). <br><br>

<a href="https://github.com/cloudnationhq/terraform-azure-pim/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=cloudnationhq/terraform-azure-pim" />
</a>

## License

MIT Licensed. See [LICENSE](./LICENSE) for full details.

## References

- [Documentation](https://learn.microsoft.com/en-us/rest/api/authorization/privileged-role-eligibility-rest-sample)
- [Rest Api](https://learn.microsoft.com/en-us/rest/api/authorization)
- [Rest Api Specs](https://github.com/Azure/azure-rest-api-specs/tree/1f449b5a17448f05ce1cd914f8ed75a0b568d130/specification/authorization/)
