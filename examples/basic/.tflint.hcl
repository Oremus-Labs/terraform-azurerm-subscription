config {
  format = "compact"
}

plugin "azurerm" {
  enabled = true
  version = "0.29.0"
  source  = "github.com/terraform-linters/tflint-ruleset-azurerm"
}

rule "terraform_deprecated_interpolation" { enabled = true }
rule "terraform_required_version" { enabled = true }
rule "terraform_naming_convention" { enabled = true }
rule "terraform_typed_variables" { enabled = true }
