module "network" {
  source = "./modules/network"

  project_name             = var.project_name
  vpc_cidr                 = var.vpc_cidr
  public_subnet_count      = var.public_subnet_count
  private_subnet_count     = var.private_subnet_count
  interface_vpc_endpoints  = var.interface_vpc_endpoints
  create_gateway_endpoints = var.create_gateway_endpoints
  tags                     = var.tags
}
