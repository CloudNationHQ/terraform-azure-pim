locals {
  pim_assignments = {
    user1 = {
      type          = "User"
      mail_nickname = "user1_pim"
      justification = "Justification for PIM assignment"
      schedule = {
        expiration = {
          duration_days = 30
        }
      }
      roles = {
        Owner = {
          scopes = [
            module.rg.groups.demo.id,
            module.rg.groups.test.id
          ]
        }
      }
    }
    user2 = {
      type            = "User"
      assignment_type = "Active"
      mail_nickname   = "user2_pim"
      justification   = "Justification for PIM assignment"
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
