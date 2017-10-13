variable "access_key" {}
variable "secret_key" {}
variable "region" {
  default = "us-east-1"
}
variable "instance_size" {
	default = "t2.small"
}

variable "ami_id" {
	default = "ami-cd0f5cb6"
}

variable "key_name" {
  description = "Name of the SSH keypair to use in AWS."
}