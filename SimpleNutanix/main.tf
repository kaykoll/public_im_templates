## Test the Generic IM Provider

provider "nutanix" {
  username     = "var.username"
  password     = "var.password"
  endpoint     = "var.endpoint"
  insecure     = true
  port         = 9440
  wait_timeout = 10
}


#######################
# Defining the Output
#######################


output "endpoint" {
	description = "Generic Endpoint"
	value       = var.endpoint
}

output "username" {
	description = "Generic Username"
	value       = var.username
}

output "password" {
	description = "Generic password"
	value       = var.password
}

output "port" {
	description = "Generic Port"
	value       = var.port
}



#######################
# Variable definitions 
#######################

variable "endpoint" {}
variable "username" {}
variable "password" {}
variable "port" {}

variable "testvar" {
	type = string
	default = "testvalue"
}

