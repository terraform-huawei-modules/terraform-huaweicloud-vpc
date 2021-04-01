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
# Subnet(s)
#
resource "huaweicloud_vpc_subnet" "this" {
  count = length(var.subnets) > 0 ? length(var.subnets) : 0

  vpc_id        = huaweicloud_vpc.this.id
  name          = lookup(var.subnets[count.index], "name", null)
  cidr          = lookup(var.subnets[count.index], "cidr", null)
  gateway_ip    = lookup(var.subnets[count.index], "gateway_ip", null)
  primary_dns   = lookup(var.subnets[count.index], "primary_dns", null)
  secondary_dns = lookup(var.subnets[count.index], "secondary_dns", null)

  tags = merge(
    {
      "Name" = format("%s", var.name)
    },
    var.tags,
    var.subnet_tags,
  )
}

#
# NAT Gateway(s)
#
resource "huaweicloud_nat_gateway" "natgw" {
  count               = var.create_nat_gateway ? 1 : 0
  name                = "${var.name}-natgw-${count.index}"
  description         = "NAT Gateway for ${var.name}"
  spec                = var.nat_gateway_spec
  router_id           = huaweicloud_vpc.this.id
  internal_network_id = huaweicloud_vpc_subnet.this.*.id[count.index]
}

resource "huaweicloud_nat_snat_rule" "natgw" {
  count          = var.create_nat_gateway ? length(huaweicloud_vpc_subnet.this.*.id) : 0
  source_type    = 0
  nat_gateway_id = huaweicloud_nat_gateway.natgw.*.id[0]
  network_id     = huaweicloud_vpc_subnet.this.*.id[count.index]
  floating_ip_id = huaweicloud_vpc_eip.natgw.*.id[0]
}

resource "huaweicloud_vpc_eip" "natgw" {
  count = var.create_nat_gateway ? 1 : 0
  publicip {
    type = "5_bgp"
  }
  bandwidth {
    name        = "${var.name}-natgw-${count.index}"
    size        = var.nat_gateway_spec
    share_type  = "PER"
    charge_mode = "traffic"
  }
}
