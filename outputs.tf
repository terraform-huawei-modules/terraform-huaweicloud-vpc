output "vpc_id" {
  description = "VPC Id"
  value       = huaweicloud_vpc.this.id
}

output "public_subnets" {
  description = "List of Public Subnet Ids"
  value       = huaweicloud_vpc_subnet.public.*.id
}

output "private_subnets" {
  description = "List of Private Subnet Ids"
  value       = huaweicloud_vpc_subnet.private.*.id
}
