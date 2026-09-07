provider "aws" {
  region = var.region
}

module "network" {
  source               = "./modules/network"
  region               = var.region
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

module "proxy_asg" {
  source             = "./modules/proxy_asg"
  ami_id             = var.ami_id
  instance_type      = var.instance_type
  private_subnet_ids = module.network.private_subnet_ids
  vpc_id             = module.network.vpc_id
  proxy_sg_id        = module.network.proxy_sg_id
}

module "privatelink" {
  source             = "./modules/privatelink"
  vpc_id             = module.network.vpc_id
  private_subnet_ids = module.network.private_subnet_ids
  #target_group_arn   = module.proxy_asg.target_group_arn
}