# Oremus Labs Azure Subscription Module

![CI](https://github.com/Oremus-Labs/terraform-azurerm-subscription/actions/workflows/ci.yml/badge.svg)
![Release Please](https://github.com/Oremus-Labs/terraform-azurerm-subscription/actions/workflows/release-please.yml/badge.svg)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit)](https://github.com/pre-commit/pre-commit)
[![Terraform Registry](https://img.shields.io/badge/Terraform-Registry-623CE4.svg)](https://registry.terraform.io/modules/OremusLabs/subscription/azurerm)

Terraform module to provision an Azure subscription, associate it to a Management Group, and manage Resource Groups with consistent tagging and location defaults.

- Registry: `Oremus-Labs/subscription/azurerm`
- Provider: `azurerm`

## Usage

```hcl
module "subscription" {
  source = "OremusLabs/subscription/azurerm"
  # version = "~> 1.0"

  subscription_key = "prod"

  config = {
    display_name        = "Prod Subscription"
    management_group_id = "/providers/Microsoft.Management/managementGroups/orm-prod"
    # or specify by name
    # management_group_name = "orm-prod"
    tags = {
      environment = "prod"
      owner       = "platform-team"
    }
    resource_group_defaults = {
      location = "eastus"
    }
    resource_groups = {
      core = {
        name = "rg-core-prod"
        tags = { cost_center = "cc-1001" }
      }
    }
  }

  default_tags = {
    organization = "Oremus Labs"
    managed-by   = "terraform"
  }

  valid_locations = [
    "eastus", "westus2", "centralus",
  ]
}
```

See a runnable example in `examples/basic`.

## Requirements

- Terraform >= 1.5
- AzureRM Provider >= 3.x

## Features

- Creates Azure Subscription with optional alias and workload
- Associates Subscription to a Management Group (optional)
- Manages multiple Resource Groups with consistent defaults
- Merges global, subscription, and per-RG tag/location defaults
- Strict validations for Azure locations and billing scope

## Contributing

- Install pre-commit: `pre-commit install`
- Run checks locally: `pre-commit run --all-files`
- Use Conventional Commits for changelog and automated releases.

## Releasing

- Merge to `main` with Conventional Commits; the `release-please` workflow opens a release PR.
- Merging the release PR creates a GitHub release and tag (e.g., `v1.0.0`).
- Terraform Registry will automatically discover the release from this repo name `terraform-azurerm-subscription`.

---

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.80.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_config"></a> [config](#input\_config) | Configuration object for the subscription. | <pre>object({<br>    display_name               = string<br>    billing_scope_id           = optional(string)<br>    billing_account_id         = optional(string)<br>    billing_profile_id         = optional(string)<br>    billing_invoice_section_id = optional(string)<br>    workload                   = optional(string)<br>    alias                      = optional(string)<br>    management_group_id        = optional(string)<br>    management_group_name      = optional(string)<br>    tags                       = optional(map(string))<br>    resource_group_defaults = optional(object({<br>      location = optional(string)<br>      tags     = optional(map(string))<br>    }))<br>    resource_groups = optional(map(object({<br>      name     = optional(string)<br>      location = optional(string)<br>      tags     = optional(map(string))<br>    })))<br>  })</pre> | n/a | yes |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | Base set of tags applied to all subscriptions and resource groups. | `map(string)` | `{}` | no |
| <a name="input_global_resource_group_defaults"></a> [global\_resource\_group\_defaults](#input\_global\_resource\_group\_defaults) | Global defaults applied to resource groups before subscription-level overrides. | <pre>object({<br>    location = optional(string)<br>    tags     = optional(map(string))<br>  })</pre> | `{}` | no |
| <a name="input_subscription_key"></a> [subscription\_key](#input\_subscription\_key) | Identifier used to reference the subscription within the root module. | `string` | n/a | yes |
| <a name="input_valid_locations"></a> [valid\_locations](#input\_valid\_locations) | Set of lowercase Azure region identifiers allowed for resource group creation. | `set(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_resource_group_details"></a> [resource\_group\_details](#output\_resource\_group\_details) | Detailed resource group information keyed by subscription/resource group. |
| <a name="output_resource_group_ids"></a> [resource\_group\_ids](#output\_resource\_group\_ids) | Map of resource group identifiers keyed by subscription/resource group. |
| <a name="output_subscription"></a> [subscription](#output\_subscription) | Detailed subscription attributes. |
| <a name="output_subscription_id"></a> [subscription\_id](#output\_subscription\_id) | Azure subscription ID for this subscription. |
<!-- END_TF_DOCS -->
