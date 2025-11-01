module "subscription" {
  source = "../.." # replace with "OremusLabs/subscription/azurerm" after publishing

  subscription_key = "dev"

  config = {
    display_name        = "Dev Subscription"
    management_group_id = "/providers/Microsoft.Management/managementGroups/orm-dev"
    resource_group_defaults = {
      location = "eastus"
    }
    resource_groups = {
      devcore = {
        name = "rg-dev-core"
        tags = { workload = "dev" }
      }
    }
  }

  default_tags = {
    organization = "Oremus Labs"
    managed-by   = "terraform"
  }

  valid_locations = ["eastus", "westus2", "centralus"]
}

output "subscription_id" {
  value = module.subscription.subscription_id
}
