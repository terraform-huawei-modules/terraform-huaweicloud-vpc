#
# VPC
#
resource "huaweicloud_vpc" "this" {
  name = var.name
  cidr = var.cidr

  tags = merge(
    {
      "Name" = format("%s", var.name)
    },
    var.tags,
    var.vpc_tags,
  )
}

#
# Public Subnet(s)
#
resource "huaweicloud_vpc_subnet" "public" {
  count = length(var.public_subnets) > 0 ? length(var.public_subnets) : 0

  vpc_id        = huaweicloud_vpc.this.id
  name          = lookup(var.public_subnets[count.index], "name", null)
  cidr          = lookup(var.public_subnets[count.index], "cidr", null)
  gateway_ip    = lookup(var.public_subnets[count.index], "gateway_ip", null)
  primary_dns   = lookup(var.public_subnets[count.index], "primary_dns", null)
  secondary_dns = lookup(var.public_subnets[count.index], "secondary_dns", null)

  tags = merge(
    {
      "Name" = format("%s-%s",
        var.name,
        var.public_subnet_suffix,
      )
    },
    var.tags,
    var.public_subnet_tags,
  )
}

#
# Private Subnet(s)
#
resource "huaweicloud_vpc_subnet" "private" {
  count = length(var.private_subnets) > 0 ? length(var.private_subnets) : 0

  vpc_id        = huaweicloud_vpc.this.id
  name          = lookup(var.private_subnets[count.index], "name", null)
  cidr          = lookup(var.private_subnets[count.index], "cidr", null)
  gateway_ip    = lookup(var.private_subnets[count.index], "gateway_ip", null)
  primary_dns   = lookup(var.private_subnets[count.index], "primary_dns", null)
  secondary_dns = lookup(var.private_subnets[count.index], "secondary_dns", null)

  tags = merge(
    {
      "Name" = format("%s-%s",
        var.name,
        var.private_subnet_suffix,
      )
    },
    var.tags,
    var.private_subnet_tags,
  )
}

#
# NAT Gateway(s)
#
resource "huaweicloud_nat_gateway" "natgw" {
  count               = var.create_nat_gateway ? length(huaweicloud_vpc_subnet.public.*.id) : 0
  name                = "${var.name}-natgw-${count.index}"
  description         = "NAT Gateway for ${huaweicloud_vpc_subnet.public.*.name[count.index]}"
  spec                = var.nat_gateway_spec
  router_id           = huaweicloud_vpc.this.id
  internal_network_id = huaweicloud_vpc_subnet.public.*.id[count.index]
}

resource "huaweicloud_nat_snat_rule" "natgw" {
  count          = var.create_nat_gateway ? length(huaweicloud_vpc_subnet.public.*.id) : 0
  nat_gateway_id = huaweicloud_nat_gateway.natgw.*.id[count.index]
  network_id     = huaweicloud_vpc_subnet.public.*.id[count.index]
  floating_ip_id = huaweicloud_vpc_eip.natgw.*.id[count.index]
}

resource "huaweicloud_vpc_eip" "natgw" {
  count = var.create_nat_gateway ? length(huaweicloud_vpc_subnet.public.*.id) : 0
  publicip {
    type = "5_bgp"
  }
  bandwidth {
    name        = "${var.name}-natgw-${count.index}"
    size        = 2
    share_type  = "PER"
    charge_mode = "traffic"
  }
}

#
# VPC Endpoints - dns is free.
#
data "huaweicloud_vpcep_public_services" "dns" {
  service_name = "dns"
}

resource "huaweicloud_vpcep_endpoint" "dns_for_public_subnets" {
  count            = length(huaweicloud_vpc_subnet.public.*.id)
  service_id       = data.huaweicloud_vpcep_public_services.dns.id
  vpc_id           = huaweicloud_vpc.this.id
  network_id       = huaweicloud_vpc_subnet.public.*.id[count.index]
  enable_dns       = true
  enable_whitelist = true
  whitelist        = [huaweicloud_vpc_subnet.public.*.cidr[count.index]]
}

resource "huaweicloud_vpcep_endpoint" "dns_for_private_subnets" {
  count            = length(huaweicloud_vpc_subnet.private.*.id)
  service_id       = data.huaweicloud_vpcep_public_services.dns.id
  vpc_id           = huaweicloud_vpc.this.id
  network_id       = huaweicloud_vpc_subnet.private.*.id[count.index]
  enable_dns       = true
  enable_whitelist = true
  whitelist        = [huaweicloud_vpc_subnet.private.*.cidr[count.index]]
}
