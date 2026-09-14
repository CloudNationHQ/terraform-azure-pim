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
    # same role (Contributor) as group1 but granted at a single, different scope, so
    # role definition lookups must be keyed per principal to avoid colliding on the
    # scope list index (see issue #25)
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
            module.rg.groups.test.id
          ]
        }
      }
    }
  }
}
