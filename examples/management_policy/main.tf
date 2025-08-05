module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.1"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 2.0"

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
  # source  = "cloudnationhq/pim/azure"
  # version = "~> 1.0"
  source = "../../"

  pim_assignments     = local.pim_assignments
  management_policies = local.management_policies
}
