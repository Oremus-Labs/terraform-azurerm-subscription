resource "azurerm_subscription" "this" {
  subscription_name = var.config.display_name
  billing_scope_id  = local.billing_scope_id
  alias             = coalesce(var.config.alias, var.subscription_key)
  workload          = coalesce(var.config.workload, "Production")
  tags              = local.subscription_tags

  lifecycle {
    precondition {
      condition     = local.billing_scope_id != null
      error_message = format("Subscription %q must resolve a billing scope using billing_scope_id or the combination of billing_account_id, billing_profile_id, and billing_invoice_section_id.", var.subscription_key)
    }
  }
}

resource "azurerm_management_group_subscription_association" "this" {
  for_each = local.management_group_id != null ? { default = local.management_group_id } : {}

  management_group_id = each.value
  subscription_id     = "/subscriptions/${azurerm_subscription.this.subscription_id}"
}

resource "azapi_resource" "resource_group" {
  for_each = local.resource_groups

  type      = "Microsoft.Resources/resourceGroups@2021-04-01"
  name      = each.value.name
  location  = each.value.location
  parent_id = "/subscriptions/${azurerm_subscription.this.subscription_id}"

  body = {
    tags = each.value.tags
  }

  lifecycle {
    precondition {
      condition = each.value.location != null && contains(
        var.valid_locations,
        lower(trimspace(each.value.location))
      )
      error_message = format("Resource group %q requires a valid Azure location. Refer to locals.valid_locations for the supported set.", each.value.name)
    }
  }
}
