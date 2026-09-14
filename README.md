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

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 5.0)

## Providers

The following providers are used by this module:

- <a name="provider_azuread"></a> [azuread](#provider\_azuread) (~> 3.0)

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 5.0)

## Resources

The following resources are used by this module:

- [azurerm_pim_active_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/pim_active_role_assignment) (resource)
- [azurerm_pim_eligible_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/pim_eligible_role_assignment) (resource)
- [azurerm_role_management_policy.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_management_policy) (resource)
- [azuread_group.approver](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) (data source)
- [azuread_group.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) (data source)
- [azuread_user.approver](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/user) (data source)
- [azuread_user.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/user) (data source)
- [azurerm_client_config.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) (data source)
- [azurerm_role_definition.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/role_definition) (data source)

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
      scopes = list(string)
    }))
    active_assignment_rules = optional(object({
      expiration_required                = optional(bool)
      expire_after                       = optional(string)
      require_justification              = optional(bool)
      require_ticket_info                = optional(bool)
      require_multifactor_authentication = optional(bool)
    }))
    eligible_assignment_rules = optional(object({
      expiration_required = optional(bool)
      expire_after        = optional(string)
    }))
    activation_rules = optional(object({
      require_justification                              = optional(bool)
      require_ticket_info                                = optional(bool)
      require_multifactor_authentication                 = optional(bool)
      required_conditional_access_authentication_context = optional(string)
      require_approval                                   = optional(bool)
      maximum_duration                                   = optional(string)
      approval_stage = optional(object({
        primary_approver = map(object({
          type                = string
          user_principal_name = optional(string)
          mail_nickname       = optional(string)
          display_name        = optional(string)
          object_id           = optional(string)
        }))
      }))
    }))
    notification_rules = optional(object({
      active_assignments = optional(object({
        admin_notifications = optional(object({
          additional_recipients = optional(list(string))
          default_recipients    = bool
          notification_level    = string
        }))
        approver_notifications = optional(object({
          additional_recipients = optional(list(string))
          default_recipients    = bool
          notification_level    = string
        }))
        assignee_notifications = optional(object({
          additional_recipients = optional(list(string))
          default_recipients    = bool
          notification_level    = string
        }))
      }))
      eligible_assignments = optional(object({
        admin_notifications = optional(object({
          additional_recipients = optional(list(string))
          default_recipients    = bool
          notification_level    = string
        }))
        approver_notifications = optional(object({
          additional_recipients = optional(list(string))
          default_recipients    = bool
          notification_level    = string
        }))
        assignee_notifications = optional(object({
          additional_recipients = optional(list(string))
          default_recipients    = bool
          notification_level    = string
        }))
      }))
      eligible_activations = optional(object({
        admin_notifications = optional(object({
          additional_recipients = optional(list(string))
          default_recipients    = bool
          notification_level    = string
        }))
        approver_notifications = optional(object({
          additional_recipients = optional(list(string))
          default_recipients    = bool
          notification_level    = string
        }))
        assignee_notifications = optional(object({
          additional_recipients = optional(list(string))
          default_recipients    = bool
          notification_level    = string
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
    object_id           = optional(string)
    assignment_type     = optional(string, "Eligible")
    user_principal_name = optional(string)
    mail_nickname       = optional(string)
    display_name        = optional(string)
    type                = string
    roles = map(object({
      scopes = list(string)
    }))
    justification     = optional(string, "No justification provided")
    condition         = optional(string)
    condition_version = optional(string, "2.0")
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

Full examples detailing most usages, along with integrations with dependency modules, are located in the examples directory.

To update the module's documentation run `make doc`

## Authors

Module is maintained by [these awesome contributors](https://github.com/cloudnationhq/terraform-azure-pim/graphs/contributors).

## Contributors

We welcome contributions from the community! Whether it's reporting a bug, suggesting a new feature, or submitting a pull request, your input is highly valued.

For more information, please see our contribution [guidelines](./CONTRIBUTING.md).

## License

MIT Licensed. See [LICENSE](./LICENSE) for full details.

## References

- [Documentation](https://learn.microsoft.com/en-us/rest/api/authorization/privileged-role-eligibility-rest-sample)
- [Rest Api](https://learn.microsoft.com/en-us/rest/api/authorization)
