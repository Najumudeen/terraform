module "dev_sg_1" {
  source = "../modules/sg"
  vpc_name = module.dev_vpc_1.vpc_name
  vpc_id = module.dev_vpc_1.vpc_id
  ingress_value = ["80", "8080", "443", "8443", "22", "3306", "1900", "1443"]
  environment = module.dev_vpc_1.environment
}


# terraform apply
# module.dev_vpc_1.aws_vpc.default
# terrafrom get
# terrafrom state list


