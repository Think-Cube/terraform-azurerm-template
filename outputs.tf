# TEMPLATE: always output id, name and the whole resource; add outputs that
# callers commonly need, such as principal_id here.
output "id" {
  description = "ID of the identity."
  value       = azurerm_user_assigned_identity.this.id
}

output "name" {
  description = "Name of the identity."
  value       = azurerm_user_assigned_identity.this.name
}

output "principal_id" {
  description = "Object ID of the identity's service principal, for role assignments."
  value       = azurerm_user_assigned_identity.this.principal_id
}

output "client_id" {
  description = "Client ID of the identity, for applications that authenticate with it."
  value       = azurerm_user_assigned_identity.this.client_id
}

output "resource" {
  description = "The whole `azurerm_user_assigned_identity` resource, for attributes without a dedicated output."
  value       = azurerm_user_assigned_identity.this
}

output "role_assignment_ids" {
  description = "IDs of the role assignments, by the keys of `role_assignments`."
  value       = { for key, assignment in azurerm_role_assignment.this : key => assignment.id }
}
