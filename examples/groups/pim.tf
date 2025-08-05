locals {
  pim_assignments = {
    group1 = {
      type          = "Group"
      display_name  = "PIM Group 1"
      justification = "Justification for PIM assignment - Eligible"
      schedule = {
        expiration = {
          duration_days = 30
        }
      }
      roles = {
        Contributor = {
          scopes = [
            module.rg.groups.demo.id,
            module.rg.groups.test.id
          ]
        }
      }
    }
    group2 = {
      type            = "Group"
      assignment_type = "Active"
      display_name    = "PIM Group 2"
      justification   = "Justification for PIM assignment - Active"
      schedule = {
        expiration = {
          duration_hours = 24
        }
      }
      roles = {
        Contributor = {
          scopes = [
            module.rg.groups.demo.id,
            module.rg.groups.test.id
          ]
        }
      }
    }
  }
}
