# terraform-gcp-vpc

Terraform module to provision a VPC.

## Examples

```hcl

module "vpc" {
  source             = "../terraform-gcp-modules/vpc"
  project_id         = var.project_id
  environment        = var.environment
  vpc_name           = "${var.environment}-vpc"
  subnet_name        = "${var.environment}-${var.region}-subnet"
  subnet_cidr        = var.cidr_block
  subnet_region      = var.region
  subnet_description = title("${var.environment} ${var.region} subnet")
}


```
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| project_id | Id of the GCP Project | string | - | yes |
| environment | Environment (e.g. `prod`, `dev`, `stg`) | string | - | yes |
| vpc_name | VPC Name | string | - | yes |
| subnet_name | Subnet Name | string | - | yes |
| subnet_cidr | CIDR for the VPC | string | - | yes |
| subnet_region | Subnet region | string | us-east1 | no |
| subnet_description | Subnet Description | string | - | no |
