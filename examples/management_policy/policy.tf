locals {
  management_policies = {
    policy1 = {
      roles = {
        Contributor = {
          scopes = [
            module.rg.groups.demo.id,
            module.rg.groups.test.id
          ]
        }
      }
      active_assignment_rules = {
        require_justification              = false
        require_ticket_info                = false
        require_multifactor_authentication = false
        expiration_required                = true
        expire_after                       = "P30D"
      }
      eligible_assignment_rules = {
        expiration_required = true
        expire_after        = "P90D"
      }
      activation_rules = {
        require_approvals                  = true
        require_multifactor_authentication = true
        require_ticket_info                = false
        require_justification              = true
        maximum_duration                   = "PT4H"
        approval_stage = {
          primary_approver = {
            user1 = {
              mail_nickname = "user1_pim"
              type          = "User"
            }
            group2_fallback = {
              display_name = "PIM Group 2"
              type         = "Group"
            }
          }
        }
      }
      notification_rules = {
        active_assignments = {
          admin_notifications = {
            default_recipients = false
            notification_level = "Critical"
          }
          approver_notifications = {
            additional_recipients = ["someone@example.com"]
            default_recipients    = false
            notification_level    = "All"
          }
          assignee_notifications = {
            additional_recipients = ["someone@example.com"]
            notification_level    = "All"
          }
        }
      }
    }
    policy2 = {
      roles = {
        Owner = {
          scopes = [
            module.rg.groups.demo.id,
            module.rg.groups.test.id
          ]
        }
        Contributor = {
          scopes = [
            module.rg.groups.demo.id,
            module.rg.groups.test.id
          ]
        }
      }
      active_assignment_rules = {
        require_justification              = true
        require_multifactor_authentication = true
        expire_after                       = "P15D"
      }
      eligible_assignment_rules = {
        expiration_required = true
        expire_after        = "P30D"
      }
      activation_rules = {
        require_approvals                  = true
        require_multifactor_authentication = true
        require_ticket_info                = true
        require_justification              = true
        maximum_duration                   = "P1D"
        approval_stage = {
          primary_approver = {
            manager = {
              mail_nickname = "user1_pim"
              type          = "User"
            }
            manager_fallback = {
              mail_nickname = "user2_pim"
              type          = "User"
            }
          }
        }
      }
    }
  }
}
