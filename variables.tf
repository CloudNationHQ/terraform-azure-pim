variable "pim_assignments" {
  description = "Map of 1 or more PIM assignment(s)"
  type = map(object({
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
  default = {}
}

variable "management_policies" {
  description = "Map of 1 or more management policies"
  type = map(object({
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
  default = {}
}
