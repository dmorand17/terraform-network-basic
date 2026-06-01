module "network" {
  source = "./modules/network"

  project_name         = var.project_name
  vpc_cidr             = var.vpc_cidr
  public_subnet_count  = var.public_subnet_count
  private_subnet_count = var.private_subnet_count
  tags                 = var.tags
}
