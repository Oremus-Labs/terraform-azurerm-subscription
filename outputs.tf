output "subscription_id" {
  description = "Azure subscription ID for this subscription."
  value       = azurerm_subscription.this.subscription_id
}

output "subscription" {
  description = "Detailed subscription attributes."
  value = {
    id                = azurerm_subscription.this.id
    subscription_id   = azurerm_subscription.this.subscription_id
    subscription_name = azurerm_subscription.this.subscription_name
    alias             = azurerm_subscription.this.alias
    tags              = azurerm_subscription.this.tags
  }
}

output "resource_group_ids" {
  description = "Map of resource group identifiers keyed by subscription/resource group."
  value = {
    for key, resource_group in azurerm_resource_group.resource_group :
    format("%s:%s", var.subscription_key, key) => resource_group.id
  }
}

output "resource_group_details" {
  description = "Detailed resource group information keyed by subscription/resource group."
  value = {
    for key, resource_group in azurerm_resource_group.resource_group :
    format("%s:%s", var.subscription_key, key) => {
      id              = resource_group.id
      name            = resource_group.name
      location        = resource_group.location
      subscription_id = azurerm_subscription.this.subscription_id
      tags            = resource_group.tags
    }
  }
}
