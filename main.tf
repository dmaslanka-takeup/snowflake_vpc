# Terraform module for AWS VPC + VPN to Snowflake

module "vpc" {
  source             = "terraform-aws-modules/vpc/aws"
  name               = var.vpc_name
  cidr               = var.vpc_cidr
  azs                = var.azs
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets
  enable_nat_gateway = true
  single_nat_gateway = true
  enable_vpn_gateway = true
  tags = var.tags
}

resource "aws_customer_gateway" "snowflake" {
  bgp_asn    = var.bgp_asn
  ip_address = var.snowflake_gateway_ip
  type       = "ipsec.1"
  tags = var.tags
}

resource "aws_vpn_connection" "to_snowflake" {
  customer_gateway_id = aws_customer_gateway.snowflake.id
  vpn_gateway_id      = module.vpc.vpn_gateway_id
  type                = "ipsec.1"
  static_routes_only  = true
  tags = var.tags
}

resource "aws_vpn_connection_route" "snowflake_route" {
  vpn_connection_id = aws_vpn_connection.to_snowflake.id
  destination_cidr_block = var.snowflake_cidr
}

variable "vpc_name" {}
variable "vpc_cidr" {}
variable "azs" { type = list(string) }
variable "private_subnets" { type = list(string) }
variable "public_subnets" { type = list(string) }
variable "tags" { type = map(string) }

variable "bgp_asn" {}
variable "snowflake_gateway_ip" {}
variable "snowflake_cidr" {}
