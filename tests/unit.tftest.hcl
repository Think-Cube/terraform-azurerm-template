# TEMPLATE: keep a run for the defaults, one for every optional feature and one
# for every validation rule.
mock_provider "azurerm" {}

variables {
  name                = "id-test-weu"
  resource_group_name = "rg-test-weu"
  location            = "westeurope"
}

run "defaults" {
  command = plan

  assert {
    condition     = azurerm_user_assigned_identity.this.name == "id-test-weu" && azurerm_user_assigned_identity.this.resource_group_name == "rg-test-weu"
    error_message = "The identity must use the given name and resource group."
  }

  assert {
    condition     = length(azurerm_management_lock.this) == 0 && length(azurerm_role_assignment.this) == 0
    error_message = "No lock or role assignment may be created by default."
  }
}

run "lock_and_role_assignments" {
  command = plan

  variables {
    lock = { kind = "ReadOnly", name = "lock-identity" }
    role_assignments = {
      operators = {
        role_definition_id_or_name = "Managed Identity Operator"
        principal_id               = "00000000-0000-0000-0000-000000000001"
        principal_type             = "Group"
      }
    }
  }

  assert {
    condition     = azurerm_management_lock.this[0].lock_level == "ReadOnly" && azurerm_management_lock.this[0].name == "lock-identity"
    error_message = "The lock must use the given kind and name."
  }

  assert {
    condition     = azurerm_role_assignment.this["operators"].role_definition_name == "Managed Identity Operator"
    error_message = "A role name must be passed as role_definition_name."
  }
}

run "rejects_invalid_name" {
  command = plan

  variables {
    name = "-starts-with-hyphen"
  }

  expect_failures = [var.name]
}

run "rejects_invalid_lock" {
  command = plan

  variables {
    lock = { kind = "DoNotDelete" }
  }

  expect_failures = [var.lock]
}
