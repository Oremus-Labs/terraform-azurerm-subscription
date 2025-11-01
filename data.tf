data "azurerm_management_group" "target" {
  count = var.config.management_group_name != null && var.config.management_group_id == null ? 1 : 0
  name  = var.config.management_group_name
}
