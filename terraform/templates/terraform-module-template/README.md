# Terraform Module Template

## Usage

```hcl
module "example" {
  source = "github.com/example/terraform-module"

  # Input variables
  env = "dev"
}
```
<!-- BEGIN_TF_DOCS -->
#### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.11.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.94.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.2.3 |

#### Providers

| Name | Version |
|------|---------|
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.3 |

#### Resources

| Name | Type |
|------|------|
| [null_resource.this](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_env"></a> [env](#input\_env) | Name of the environment | `string` | `"dev"` | no |

#### Outputs

| Name | Description |
|------|-------------|
| <a name="output_env"></a> [env](#output\_env) | The environment name |
| <a name="output_null_resource"></a> [null\_resource](#output\_null\_resource) | This null resource |
<!-- END_TF_DOCS -->
