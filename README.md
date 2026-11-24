# terraform-azurerm-template

Template for Think-Cube Terraform modules for Azure. It contains the shared CI, community files and the interface every module follows, around a sample module for a user-assigned identity.

## Create a module from this template

1. Create the repository from the template, named `terraform-azurerm-<name>`:

   ```bash
   gh repo create Think-Cube/terraform-azurerm-<name> --public --template Think-Cube/terraform-azurerm-template --description "..."
   ```

2. Replace the identity in `main.tf`, `variables.tf`, `outputs.tf`, `tests/` and `examples/` with the module's resource, and remove the `TEMPLATE:` comments.
3. Replace this section with a description and usage example, and regenerate the tables with `terraform-docs .`.
4. Apply the repository settings and the ruleset that requires `module / lint` and `module / test`.
5. Release `v1.0.0` once CI passes.

## Usage

```hcl
module "identity" {
  source = "git::https://github.com/Think-Cube/terraform-azurerm-<name>.git?ref=v1.0.0"

  name                = "id-app-prod-weu"
  resource_group_name = "rg-app-prod-weu"
  location            = "westeurope"
}
```

Pin `ref` to a release tag. Dependabot's `terraform` ecosystem proposes new releases of modules sourced this way.

The module does not configure the `azurerm` provider; configure it in your root module.

## Development

The module is tested with `terraform test` against a mocked `azurerm` provider, so no Azure subscription is needed:

```bash
terraform fmt -recursive
terraform init -backend=false
terraform test
terraform-docs .
```

Pull requests also run TFLint with the azurerm ruleset, a Trivy misconfiguration scan and the tests on the oldest and newest supported Terraform versions.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| terraform | >= 1.14 |
| azurerm | >= 5.0, < 6.0 |

## Providers

| Name | Version |
| ---- | ------- |
| azurerm | >= 5.0, < 6.0 |

## Resources

| Name | Type |
| ---- | ---- |
| [azurerm_management_lock.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) | resource |
| [azurerm_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_user_assigned_identity.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| location | Azure region of the identity, such as `westeurope`. | `string` | n/a | yes |
| name | Name of the user-assigned identity. Changing it creates a new identity. | `string` | n/a | yes |
| resource_group_name | Name of the resource group to create the identity in. | `string` | n/a | yes |
| lock | Management lock on the identity:<br/>- `kind`: `CanNotDelete` or `ReadOnly`.<br/>- `name`: lock name; defaults to `lock-<kind>`.<br/>- `notes`: why the lock exists. | <pre>object({<br/>    kind  = string<br/>    name  = optional(string)<br/>    notes = optional(string)<br/>  })</pre> | `null` | no |
| role_assignments | Role assignments on the identity, keyed by any name that stays stable:<br/>- `role_definition_id_or_name`: built-in role name such as `Reader`, or a role definition ID starting with `/`.<br/>- `principal_id`: object ID of the user, group, service principal or managed identity.<br/>- `principal_type`: `User`, `Group` or `ServicePrincipal`. Set it for principals created in the same run to avoid replication delays.<br/>- `description`, `condition`, `condition_version`: optional description and ABAC condition.<br/>- `skip_service_principal_aad_check`: skip the Entra ID check for a service principal created in the same run.<br/>- `delegated_managed_identity_resource_id`: managed identity for cross-tenant scenarios. | <pre>map(object({<br/>    role_definition_id_or_name             = string<br/>    principal_id                           = string<br/>    principal_type                         = optional(string)<br/>    description                            = optional(string)<br/>    condition                              = optional(string)<br/>    condition_version                      = optional(string)<br/>    skip_service_principal_aad_check       = optional(bool, false)<br/>    delegated_managed_identity_resource_id = optional(string)<br/>  }))</pre> | `{}` | no |
| tags | Tags assigned to the identity. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| client_id | Client ID of the identity, for applications that authenticate with it. |
| id | ID of the identity. |
| name | Name of the identity. |
| principal_id | Object ID of the identity's service principal, for role assignments. |
| resource | The whole `azurerm_user_assigned_identity` resource, for attributes without a dedicated output. |
| role_assignment_ids | IDs of the role assignments, by the keys of `role_assignments`. |
<!-- END_TF_DOCS -->

## License

This project is licensed under the [MIT License](LICENSE).
