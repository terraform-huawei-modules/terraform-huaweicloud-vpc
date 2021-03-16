variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = "0.0.0.0/0"
}

variable "public_subnet_suffix" {
  description = "Suffix to append to public subnets name"
  type        = string
  default     = "public"
}

variable "private_subnet_suffix" {
  description = "Suffix to append to private subnets name"
  type        = string
  default     = "private"
}

variable "create_nat_gateway" {
  description = "Whether to create NAT Gateway or not"
  type        = bool
  default     = true
}

variable "nat_gateway_spec" {
  description = "NAT Gateway SNAT Connection. Values are 1, 2, 3, 4"
  type        = number
  default     = 2
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type = list(object({
    name          = string
    cidr          = string
    gateway_ip    = string
    primary_dns   = string
    secondary_dns = string
  }))
  default = []
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type = list(object({
    name          = string
    cidr          = string
    gateway_ip    = string
    primary_dns   = string
    secondary_dns = string
  }))
  default = []
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "vpc_tags" {
  description = "Additional tags for the VPC"
  type        = map(string)
  default     = {}
}

variable "public_subnet_tags" {
  description = "Additional tags for the public subnets"
  type        = map(string)
  default = {
    Type = "public"
  }
}

variable "private_subnet_tags" {
  description = "Additional tags for the private subnets"
  type        = map(string)
  default = {
    Type = "private"
  }
}
