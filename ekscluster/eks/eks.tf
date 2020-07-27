provider "aws" {
  version = "= 2.50.0"

  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}

terraform {
  backend "s3" {}
}

module "ekscluster" {
  source              = "../modules/eks"
  keyname             = var.keyname
  subnet_ids          = var.subnet_ids
  desired_size        = var.desired_size
  max_size            = var.max_size
  min_size            = var.min_size
  eksmaster_name      = var.eksmaster_name
  eksnode_name        = var.eksnode_name
  eksmaster_role_name = var.eksmaster_role_name
  eksnode_role_name   = var.eksnode_role_name
}
