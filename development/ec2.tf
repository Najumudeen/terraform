module "dev_ec2_1" {

  source      = "../modules/compute"
  aws_region  = var.aws_region
  key_name    = "SecOps-Key"
  environment = module.dev_vpc_1.environment
  amis = {
    us-east-1 = "ami-yyryryryryr"
    us-east-2 = "ami-bfbfbfbfbff"
  }
  public_subnets  = module.dev_vpc_1.public_subnet
  private_subnets = module.dev_vpc_1.private_subnet
  sg_id           = module.dev_sg_1.sg_id
  vpc_name        = module.dev_vpc_1.vpc_name


  # elb_listener = module.dev_vpc_1.elb_listener
  # elb_listener = module.dev_vpc_1_public.elb_listener
}


# module "dev_elb_1" {
#   source = "../modules/elb"
#   environment = module.dev_vpc_1.environment
#   nlbname     = module.dev_vpc_1.public_subnets_id_1
#   tgname      = "dev-nlb-tg"
#   vpc_id      = module.dev_vpc_1.vpc_id
#   private_servers = module.dev_compute_1.private_servers
# }

# module "dev_elb_1_public" {
#   source = "../modules/elb"
#   environment = module.dev_vpc_1.environment
#   nlbname     = module.dev_vpc_1.public_subnets_id
#   tgname      = "dev-nlb-tg-public"
#   vpc_id      = module.dev_vpc_1.vpc_id
#   private_servers = module.dev_compute_1.public_servers
# }