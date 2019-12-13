# Read also the Terraform GCP provider documentation
# https://www.terraform.io/docs/providers/google/getting_started.html

locals {
	credential_path = "/home/automic/terraform_creds"	
}

provider "google" {
#  Terraform commandline uses environment variable GOOGLE_CLOUD_KEYFILE_JSON=<GCP JSON>. 
#  -> IM uses the values defined in the CDA Infrastructure Provider
  credentials = var.gc_credentials
  project     = var.gcp_project
  region      = var.gcp_region
}

resource "google_compute_instance" "default" {
  project      = var.gcp_project
  zone         = var.gcp_zone
  name         = "${var.gcp_infrastructure_name}-${local.id}"
  machine_type = var.gcp_machine_type
  
  boot_disk {
    initialize_params {
      image = var.gcp_image
    }
  }
  # A default network is created for all GCP projects  
  network_interface {
    network 	  = "default"
#	network       = "google_compute_network.vpc_network.self_link"
    access_config {
    }
  }
}

locals {
	id = random_integer.name_extension.result
}

resource "random_integer" "name_extension" {
  min     = 1
  max     = 99999
}


#resource "google_compute_network" "vpc_network" {
#  name                    = "default"
#  auto_create_subnetworks = "true"
#}



#######################
# Defining the Output
#######################


output "instance_name" {
	description = "Instance name"
	value       = google_compute_instance.default.*.name[0]
}

output "project_output" {
	description = "Project name"
	value       = google_compute_instance.default.*.project[0]
}

output "internal_ip_output" {
	description = "Internal IP"
	value       = google_compute_instance.default.*.network_interface.0.network_ip
}

output "external_ip_output" {
	description = "External IP "
	value 		= google_compute_instance.default.*.network_interface.0.access_config.0.nat_ip
}


#######################
# Variable definitions 
#######################

variable "credentials" {}
variable "gc_credentials" {}

variable "credential_path" {
	type = string
	default = "/cred"
}

variable "gcp_project" {
	type = string
	default = "default"
}

variable "gcp_region" {
	type = string
	default = "europe-west3"
}

variable "gcp_zone" {
	type = string
	default = "europe-west3-c"
}

variable "gcp_image" {
	type = string
	default = "gcp_image_name"
}

variable "gcp_infrastructure_name" {
	type = string
	default = "infrastructure"
}

variable "gcp_machine_type" {
	type = string
	default = "f1-micro"
}

