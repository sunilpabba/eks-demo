variable "aws_access_key" {
}

variable "aws_secret_key" {
}

variable "aws_region" {
}

variable "keyname" {
}

variable "subnet_ids" {
  type = list(string)
}

variable "desired_size" {
  default = 1
}

variable "max_size" {
  default = 1
}

variable "min_size" {
  default = 1
}

variable "eksmaster_name" {
  default = "eks-cluster"
}

variable "eksnode_name" {
  default = "eks-node"
}

variable "eksmaster_role_name" {
  default = "eks-cluster-role"
}

variable "eksnode_role_name" {
  default = "eks-node-role"
}
