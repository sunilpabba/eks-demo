variable "keyname" {}

variable "subnet_ids" {
  type = list(string)
}

variable "desired_size" {}

variable "max_size" {}

variable "min_size" {}

variable "eksmaster_name" {}

variable "eksnode_name" {}

variable "eksmaster_role_name" {}

variable "eksnode_role_name" {}
