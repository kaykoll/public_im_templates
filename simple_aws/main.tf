# Expects two environment variables defined on the system which runs Terraform
# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY
variable "access_key" {}
variable "secret_key" {}

provider "aws" {
  region = "eu-central-1"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
}

resource "aws_instance" "IM_demo_env" {
  ami = "ami-00aa4671cbf840d82"
  instance_type = "t2.micro"

tags = {
    Name = "Terraform Demo from Service Catalog"
	}
  }
