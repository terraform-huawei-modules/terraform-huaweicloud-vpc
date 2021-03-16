## Requirements

| Name | Version |
|------|---------|
| huaweicloud | ~> 1.22 |

## Providers

| Name | Version |
|------|---------|
| huaweicloud | ~> 1.22 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [huaweicloud_nat_gateway](https://registry.terraform.io/providers/huaweicloud/huaweicloud/latest/docs/resources/nat_gateway) |
| [huaweicloud_nat_snat_rule](https://registry.terraform.io/providers/huaweicloud/huaweicloud/latest/docs/resources/nat_snat_rule) |
| [huaweicloud_vpc](https://registry.terraform.io/providers/huaweicloud/huaweicloud/latest/docs/resources/vpc) |
| [huaweicloud_vpc_eip](https://registry.terraform.io/providers/huaweicloud/huaweicloud/latest/docs/resources/vpc_eip) |
| [huaweicloud_vpc_subnet](https://registry.terraform.io/providers/huaweicloud/huaweicloud/latest/docs/resources/vpc_subnet) |
| [huaweicloud_vpcep_endpoint](https://registry.terraform.io/providers/huaweicloud/huaweicloud/latest/docs/resources/vpcep_endpoint) |
| [huaweicloud_vpcep_public_services](https://registry.terraform.io/providers/huaweicloud/huaweicloud/latest/docs/data-sources/vpcep_public_services) |

## Usage

```hcl
module "vpc" {
  source          = "git::https://github.com/terraform-huawei-modules/terraform-huaweicloud-vpc.git?ref=0.1.0"

  name = "my-vpc"
  cidr = "10.123.0.0/22"

  create_nat_gateway = true

  public_subnets = [
    {
      name          = "my-public-subnet"
      cidr          = "10.123.0.0/23"
      gateway_ip    = "10.123.0.1"
      primary_dns   = "100.125.1.250"
      secondary_dns = "182.50.80.4"
    }
  ]

  private_subnets = [
    {
      name          = "my-private-subnet"
      cidr          = "10.123.2.0/23"
      gateway_ip    = "10.123.2.1"
      primary_dns   = "100.125.1.250"
      secondary_dns = "182.50.80.4"
    }
  ]

  tags = {
    managed_by = "Terraform"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cidr | The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden | `string` | `"0.0.0.0/0"` | no |
| create\_nat\_gateway | Whether to create NAT Gateway or not | `bool` | `true` | no |
| name | Name to be used on all the resources as identifier | `string` | `""` | no |
| nat\_gateway\_spec | NAT Gateway SNAT Connection. Values are 1, 2, 3, 4 | `number` | `2` | no |
| private\_route\_table\_tags | Additional tags for the private route tables | `map(string)` | `{}` | no |
| private\_subnet\_suffix | Suffix to append to private subnets name | `string` | `"private"` | no |
| private\_subnet\_tags | Additional tags for the private subnets | `map(string)` | <pre>{<br>  "Type": "private"<br>}</pre> | no |
| private\_subnets | A list of private subnets inside the VPC | <pre>list(object({<br>    name          = string<br>    cidr          = string<br>    gateway_ip    = string<br>    primary_dns   = string<br>    secondary_dns = string<br>  }))</pre> | `[]` | no |
| public\_route\_table\_tags | Additional tags for the public route tables | `map(string)` | `{}` | no |
| public\_subnet\_suffix | Suffix to append to public subnets name | `string` | `"public"` | no |
| public\_subnet\_tags | Additional tags for the public subnets | `map(string)` | <pre>{<br>  "Type": "public"<br>}</pre> | no |
| public\_subnets | A list of public subnets inside the VPC | <pre>list(object({<br>    name          = string<br>    cidr          = string<br>    gateway_ip    = string<br>    primary_dns   = string<br>    secondary_dns = string<br>  }))</pre> | `[]` | no |
| tags | A map of tags to add to all resources | `map(string)` | `{}` | no |
| vpc\_tags | Additional tags for the VPC | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| private\_subnets | List of Private Subnet Ids |
| public\_subnets | List of Public Subnet Ids |
| vpc\_id | VPC Id |
