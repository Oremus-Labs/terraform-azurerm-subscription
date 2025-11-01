variable "subscription_key" {
  description = "Identifier used to reference the subscription within the root module."
  type        = string
}

variable "config" {
  description = "Configuration object for the subscription."
  type = object({
    display_name               = string
    billing_scope_id           = optional(string)
    billing_account_id         = optional(string)
    billing_profile_id         = optional(string)
    billing_invoice_section_id = optional(string)
    workload                   = optional(string)
    alias                      = optional(string)
    management_group_id        = optional(string)
    management_group_name      = optional(string)
    tags                       = optional(map(string))
    resource_group_defaults = optional(object({
      location = optional(string)
      tags     = optional(map(string))
    }))
    resource_groups = optional(map(object({
      name     = optional(string)
      location = optional(string)
      tags     = optional(map(string))
    })))
  })
}

variable "default_tags" {
  description = "Base set of tags applied to all subscriptions and resource groups."
  type        = map(string)
  default     = {}
}

variable "global_resource_group_defaults" {
  description = "Global defaults applied to resource groups before subscription-level overrides."
  type = object({
    location = optional(string)
    tags     = optional(map(string))
  })
  default = {}
}

variable "valid_locations" {
  description = "Set of lowercase Azure region identifiers allowed for resource group creation."
  type        = set(string)
}
