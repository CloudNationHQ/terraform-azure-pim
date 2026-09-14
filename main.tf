# existing
data "azurerm_client_config" "this" {}

data "azuread_group" "this" {
  for_each = {
    for gr in local.pim_assignments :
    gr.key => gr if gr.type == "Group" && gr.object_id == null
  }

  display_name = each.value.display_name
}

data "azuread_user" "this" {
  for_each = {
    for user in local.pim_assignments :
    user.key => user if user.type == "User" && user.object_id == null
  }

  user_principal_name = each.value.user_principal_name
  mail_nickname       = each.value.mail_nickname
}

data "azuread_user" "approver" {
  for_each = {
    for user in local.approvers :
    user.key => user if user.type == "User" && user.object_id == null
  }

  user_principal_name = each.value.user_principal_name
  mail_nickname       = each.value.mail_nickname
}

data "azuread_group" "approver" {
  for_each = {
    for group in local.approvers :
    group.key => group if group.type == "Group" && group.object_id == null
  }

  display_name = each.value.display_name
}

data "azurerm_role_definition" "this" {
  for_each = local.all_role_definitions

  name  = each.value.role_name
  scope = each.value.scope
}

# pim active role assignments
resource "azurerm_pim_active_role_assignment" "this" {
  for_each = {
    for pim in local.pim_assignments :
    pim.key => pim if pim.assignment_type == "Active"
  }

  principal_id = (each.value.object_id != null ? each.value.object_id : each.value.type == "User" ?
  data.azuread_user.this[each.value.key].object_id : data.azuread_group.this[each.value.key].object_id)
  scope              = each.value.scope != null ? each.value.scope : data.azurerm_client_config.this.subscription_id
  role_definition_id = data.azurerm_role_definition.this[each.value.key_role_definition].role_definition_resource_id
  justification      = each.value.justification

  dynamic "schedule" {
    for_each = each.value.schedule != null ? { "this" = each.value.schedule } : {}

    content {
      start_date_time = schedule.value.start_date_time

      dynamic "expiration" {
        for_each = schedule.value.expiration != null ? { "this" = schedule.value.expiration } : {}

        content {
          duration_days  = expiration.value.duration_days
          duration_hours = expiration.value.duration_hours
          end_date_time  = expiration.value.end_date_time
        }
      }
    }
  }

  dynamic "ticket" {
    for_each = each.value.ticket != null ? { "this" = each.value.ticket } : {}

    content {
      number = ticket.value.number
      system = ticket.value.system
    }
  }
}

# pim eligible role assignments
resource "azurerm_pim_eligible_role_assignment" "this" {
  for_each = {
    for pim in local.pim_assignments :
    pim.key => pim if pim.assignment_type == "Eligible"
  }

  principal_id = (each.value.object_id != null ? each.value.object_id : each.value.type == "User" ?
  data.azuread_user.this[each.value.key].object_id : data.azuread_group.this[each.value.key].object_id)
  scope              = each.value.scope != null ? each.value.scope : data.azurerm_client_config.this.subscription_id
  role_definition_id = data.azurerm_role_definition.this[each.value.key_role_definition].role_definition_resource_id
  justification      = each.value.justification
  condition          = each.value.condition
  condition_version  = each.value.condition_version

  dynamic "schedule" {
    for_each = each.value.schedule != null ? { "this" = each.value.schedule } : {}

    content {
      start_date_time = schedule.value.start_date_time

      dynamic "expiration" {
        for_each = schedule.value.expiration != null ? { "this" = schedule.value.expiration } : {}

        content {
          duration_days  = expiration.value.duration_days
          duration_hours = expiration.value.duration_hours
          end_date_time  = expiration.value.end_date_time
        }
      }
    }
  }

  dynamic "ticket" {
    for_each = each.value.ticket != null ? { "this" = each.value.ticket } : {}

    content {
      number = ticket.value.number
      system = ticket.value.system
    }
  }
}

# role management policies
resource "azurerm_role_management_policy" "this" {
  for_each = {
    for policy in local.management_policies : policy.key => policy
  }

  scope              = each.value.scope != null ? each.value.scope : data.azurerm_client_config.this.subscription_id
  role_definition_id = data.azurerm_role_definition.this[each.value.key_role_definition].role_definition_resource_id

  dynamic "active_assignment_rules" {
    for_each = each.value.active_assignment_rules != null ? { "this" = each.value.active_assignment_rules } : {}

    content {
      expiration_required                = active_assignment_rules.value.expiration_required
      expire_after                       = active_assignment_rules.value.expire_after
      require_justification              = active_assignment_rules.value.require_justification
      require_ticket_info                = active_assignment_rules.value.require_ticket_info
      require_multifactor_authentication = active_assignment_rules.value.require_multifactor_authentication
    }
  }

  dynamic "eligible_assignment_rules" {
    for_each = each.value.eligible_assignment_rules != null ? { "this" = each.value.eligible_assignment_rules } : {}

    content {
      expiration_required = eligible_assignment_rules.value.expiration_required
      expire_after        = eligible_assignment_rules.value.expire_after
    }
  }

  dynamic "activation_rules" {
    for_each = each.value.activation_rules != null ? { "this" = each.value.activation_rules } : {}

    content {
      require_justification                              = activation_rules.value.require_justification
      require_ticket_info                                = activation_rules.value.require_ticket_info
      require_multifactor_authentication                 = activation_rules.value.require_multifactor_authentication
      required_conditional_access_authentication_context = activation_rules.value.required_conditional_access_authentication_context
      require_approval                                   = activation_rules.value.require_approval
      maximum_duration                                   = activation_rules.value.maximum_duration

      dynamic "approval_stage" {
        for_each = activation_rules.value.approval_stage != null ? { "this" = activation_rules.value.approval_stage } : {}

        content {
          dynamic "primary_approver" {
            for_each = approval_stage.value.primary_approver

            content {
              object_id = (
                primary_approver.value.object_id != null ?
                primary_approver.value.object_id : primary_approver.value.type == "User" ?
                data.azuread_user.approver["${each.value.key_policy}-${primary_approver.key}"].object_id :
                data.azuread_group.approver["${each.value.key_policy}-${primary_approver.key}"].object_id
              )
              type = primary_approver.value.type
            }
          }
        }
      }
    }
  }

  dynamic "notification_rules" {
    for_each = each.value.notification_rules != null ? { "this" = each.value.notification_rules } : {}

    content {
      dynamic "active_assignments" {
        for_each = notification_rules.value.active_assignments != null ? { "this" = notification_rules.value.active_assignments } : {}

        content {
          dynamic "admin_notifications" {
            for_each = active_assignments.value.admin_notifications != null ? { "this" = active_assignments.value.admin_notifications } : {}

            content {
              additional_recipients = admin_notifications.value.additional_recipients
              notification_level    = admin_notifications.value.notification_level
              default_recipients    = admin_notifications.value.default_recipients
            }
          }
          dynamic "approver_notifications" {
            for_each = active_assignments.value.approver_notifications != null ? { "this" = active_assignments.value.approver_notifications } : {}

            content {
              additional_recipients = approver_notifications.value.additional_recipients
              notification_level    = approver_notifications.value.notification_level
              default_recipients    = approver_notifications.value.default_recipients
            }
          }
          dynamic "assignee_notifications" {
            for_each = active_assignments.value.assignee_notifications != null ? { "this" = active_assignments.value.assignee_notifications } : {}

            content {
              additional_recipients = assignee_notifications.value.additional_recipients
              notification_level    = assignee_notifications.value.notification_level
              default_recipients    = assignee_notifications.value.default_recipients
            }
          }
        }
      }

      dynamic "eligible_assignments" {
        for_each = notification_rules.value.eligible_assignments != null ? { "this" = notification_rules.value.eligible_assignments } : {}

        content {
          dynamic "admin_notifications" {
            for_each = eligible_assignments.value.admin_notifications != null ? { "this" = eligible_assignments.value.admin_notifications } : {}

            content {
              additional_recipients = admin_notifications.value.additional_recipients
              notification_level    = admin_notifications.value.notification_level
              default_recipients    = admin_notifications.value.default_recipients
            }
          }
          dynamic "approver_notifications" {
            for_each = eligible_assignments.value.approver_notifications != null ? { "this" = eligible_assignments.value.approver_notifications } : {}

            content {
              additional_recipients = approver_notifications.value.additional_recipients
              notification_level    = approver_notifications.value.notification_level
              default_recipients    = approver_notifications.value.default_recipients
            }
          }
          dynamic "assignee_notifications" {
            for_each = eligible_assignments.value.assignee_notifications != null ? { "this" = eligible_assignments.value.assignee_notifications } : {}

            content {
              additional_recipients = assignee_notifications.value.additional_recipients
              notification_level    = assignee_notifications.value.notification_level
              default_recipients    = assignee_notifications.value.default_recipients
            }
          }
        }
      }

      dynamic "eligible_activations" {
        for_each = notification_rules.value.eligible_activations != null ? { "this" = notification_rules.value.eligible_activations } : {}

        content {
          dynamic "admin_notifications" {
            for_each = eligible_activations.value.admin_notifications != null ? { "this" = eligible_activations.value.admin_notifications } : {}

            content {
              additional_recipients = admin_notifications.value.additional_recipients
              notification_level    = admin_notifications.value.notification_level
              default_recipients    = admin_notifications.value.default_recipients
            }
          }
          dynamic "approver_notifications" {
            for_each = eligible_activations.value.approver_notifications != null ? { "this" = eligible_activations.value.approver_notifications } : {}

            content {
              additional_recipients = approver_notifications.value.additional_recipients
              notification_level    = approver_notifications.value.notification_level
              default_recipients    = approver_notifications.value.default_recipients
            }
          }
          dynamic "assignee_notifications" {
            for_each = eligible_activations.value.assignee_notifications != null ? { "this" = eligible_activations.value.assignee_notifications } : {}

            content {
              additional_recipients = assignee_notifications.value.additional_recipients
              notification_level    = assignee_notifications.value.notification_level
              default_recipients    = assignee_notifications.value.default_recipients
            }
          }
        }
      }
    }
  }
}
