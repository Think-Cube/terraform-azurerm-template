# Contributing

Thank you for your interest in contributing!

## How to Contribute

1. **Fork** this repository.
2. **Create a branch**: `git checkout -b fix/description` or `feat/description`
3. **Make your changes** — see guidelines below.
4. **Open a Pull Request** using the PR template.

## Module Guidelines

- Keep the module focused on one resource and what is attached to it, such as a lock and role assignments. Other resources belong in their own modules.
- Keep the shared interface: `name`, `resource_group_name`, `location`, `tags`, `lock` and `role_assignments`, and the outputs `id`, `name` and `resource`.
- Give every variable a `description` and a `type`, and validate values where Azure has rules.
- Do not configure providers in the module; the root module does that.
- Cover new behaviour with a `run` block in `tests/`, and update the examples when the interface changes.
- Do not embed secrets, tokens, or credentials.

Releases follow semantic versioning. Removing or renaming a variable or output, or a change that replaces existing resources, needs a new major version.

## Testing Locally

The tests use a mocked `azurerm` provider, so they need no Azure subscription:

```bash
terraform fmt -recursive
terraform init -backend=false
terraform validate
terraform test
```

Regenerate the tables in the README after changing variables or outputs, with the terraform-docs version named in the CI log:

```bash
terraform-docs .
```

Pull requests run the same checks, plus TFLint and a Trivy misconfiguration scan.

## Reporting Issues

Use the issue templates:
- **Bug report** — something is broken or behaves unexpectedly.
- **Feature request** — suggest an improvement.

## Code of Conduct

By contributing, you agree to abide by our [Code of Conduct](CODE_OF_CONDUCT.md).
