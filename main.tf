module "vpc" {

  source = "git::https://github.com/srini123k/tf-module-vpc.git"
  env=var.env
  tags=var.tags

  for_each = var.vpc
  vpc_cidr=each.value["vpc_cidr"]
  public_subnets = each.value["public_subnets"]

}
