module "vpc" {
  source              = "terraform-aws-modules/vpc/aws"
  version             = "3.14.0"
  tags                = var.tags
  vpc_tags            = merge(var.vpc_tags, local.vpc_tags)
  private_subnet_tags = merge(var.tags, var.private_subnet_tags)
  public_subnet_tags  = merge(var.tags, var.public_subnet_tags)
  name                = var.name
  cidr                = var.cidr
  azs                 = var.azs

  private_subnets  = var.private_subnets
  public_subnets   = var.public_subnets
  database_subnets = var.database_subnets

  propagate_private_route_tables_vgw = var.propagate_private_route_tables_vgw
  enable_vpn_gateway                 = var.enable_vpn_gateway
  enable_dns_hostnames               = var.enable_dns_hostnames

  create_igw             = var.create_igw
  create_egress_only_igw = var.create_egress_only_igw

  enable_nat_gateway     = var.enable_nat_gateway
  single_nat_gateway     = var.single_nat_gateway
  one_nat_gateway_per_az = var.one_nat_gateway_per_az
  reuse_nat_ips          = var.reuse_nat_ips
  external_nat_ip_ids    = aws_eip.nat.*.id

  enable_dhcp_options               = var.enable_dhcp_options
  dhcp_options_domain_name          = var.dhcp_options_domain_name
  dhcp_options_domain_name_servers  = var.dhcp_options_domain_name_servers
  dhcp_options_ntp_servers          = var.dhcp_options_ntp_servers
  dhcp_options_netbios_name_servers = var.dhcp_options_netbios_name_servers
  dhcp_options_netbios_node_type    = var.dhcp_options_netbios_node_type
}