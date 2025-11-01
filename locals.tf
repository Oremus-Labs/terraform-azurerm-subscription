locals {
  billing_scope_id = coalesce(
    var.config.billing_scope_id,
    var.config.billing_account_id != null && var.config.billing_profile_id != null && var.config.billing_invoice_section_id != null ?
    "/providers/Microsoft.Billing/billingAccounts/${var.config.billing_account_id}/billingProfiles/${var.config.billing_profile_id}/invoiceSections/${var.config.billing_invoice_section_id}" :
    null
  )

  subscription_tags = merge(
    var.default_tags,
    var.config.tags != null ? var.config.tags : {}
  )

  global_defaults = {
    location = var.global_resource_group_defaults.location
    tags     = merge(var.default_tags, var.global_resource_group_defaults.tags != null ? var.global_resource_group_defaults.tags : {})
  }

  subscription_defaults = {
    location = coalesce(
      var.config.resource_group_defaults != null ? var.config.resource_group_defaults.location : null,
      local.global_defaults.location
    )
    tags = merge(
      local.global_defaults.tags,
      var.config.resource_group_defaults != null && var.config.resource_group_defaults.tags != null ? var.config.resource_group_defaults.tags : {}
    )
  }

  resource_groups = {
    for rg_key, rg_config in coalesce(var.config.resource_groups, {}) : rg_key => {
      name     = coalesce(rg_config.name, rg_key)
      location = coalesce(rg_config.location, local.subscription_defaults.location)
      tags     = merge(local.subscription_defaults.tags, rg_config.tags != null ? rg_config.tags : {})
    }
  }
}
