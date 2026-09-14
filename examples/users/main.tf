module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.1"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 3.0"

  groups = {
    demo = {
      name     = "${module.naming.resource_group.name_unique}-demo"
      location = "westeurope"
    }
    test = {
      name     = "${module.naming.resource_group.name_unique}-test"
      location = "westeurope"
    }
  }
}

module "pim" {
  source  = "cloudnationhq/pim/azure"
  version = "~> 2.0"

  pim_assignments = local.pim_assignments
}
