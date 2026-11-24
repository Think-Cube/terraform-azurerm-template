# TEMPLATE: replace the user-assigned identity with the module's main resource,
# and keep the lock and role assignments when the resource supports them.
resource "azurerm_user_assigned_identity" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

resource "azurerm_management_lock" "this" {
  count = var.lock == null ? 0 : 1

  name       = coalesce(var.lock.name, "lock-${var.lock.kind}")
  scope      = azurerm_user_assigned_identity.this.id
  lock_level = var.lock.kind
  notes      = var.lock.notes
}

resource "azurerm_role_assignment" "this" {
  for_each = var.role_assignments

  scope                                  = azurerm_user_assigned_identity.this.id
  principal_id                           = each.value.principal_id
  principal_type                         = each.value.principal_type
  role_definition_id                     = startswith(each.value.role_definition_id_or_name, "/") ? each.value.role_definition_id_or_name : null
  role_definition_name                   = startswith(each.value.role_definition_id_or_name, "/") ? null : each.value.role_definition_id_or_name
  description                            = each.value.description
  condition                              = each.value.condition
  condition_version                      = each.value.condition_version
  skip_service_principal_aad_check       = each.value.skip_service_principal_aad_check
  delegated_managed_identity_resource_id = each.value.delegated_managed_identity_resource_id
}
