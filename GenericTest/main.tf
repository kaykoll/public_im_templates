## Test the Generic IM Provider


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

