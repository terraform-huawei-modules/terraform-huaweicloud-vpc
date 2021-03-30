output "vpc_id" {
  description = "VPC Id"
  value       = huaweicloud_vpc.this.id
}

output "subnets" {
  description = "List of Subnet Ids"
  value       = huaweicloud_vpc_subnet.this.*.id
}
