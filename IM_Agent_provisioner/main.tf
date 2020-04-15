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

resource "google_compute_firewall" "ssh-automic-cp-sm-firewall" {
	name    = "ssh-automic-cp-sm-firewall-${local.id}"
	network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22", "2217", "2218", "2219", "2300", "8871"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh-automic-cp-sm-firewall-${local.id}"]
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
#		network       = google_compute_network.vpc_network.self_link
		access_config {
		}
	}
	
	tags = [
		"ssh-automic-cp-sm-firewall-${local.id}"
	]	
	

	metadata = {
		ssh-keys = "${var.gcp_linux_user}:${file("${local.credential_path}/${var.gcp_public_key_file}")}"
	}

	depends_on = [google_compute_firewall.ssh-automic-cp-sm-firewall]		
	
	provisioner "automic_agent_install" {
  		destination = var.remote_working_dir
		source = "/home/automic/agentfiles/"

		agent_name = random_string.append_string.result
		agent_port = var.agent_port
		ae_system_name = var.ae_system_name
		ae_host = var.ae_host
		ae_port = var.ae_port
		sm_port = var.sm_port
		sm_name = "${var.sm_name}${random_string.append_string.result}"

#		variables = {
#			UC_EX_IP_ADDR = google_compute_instance.default.network_interface.0.access_config.0.nat_ip
#		}

		connection {
			type	= "ssh"
			user	= var.gcp_linux_user
			private_key	= file("${local.credential_path}/${var.gcp_private_key_file}")
			timeout		= "500s"
			host = google_compute_instance.default.network_interface.0.access_config.0.nat_ip
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

resource "random_string" "append_string" {
	length  = 10
	special = false
	lower   = false
}




#######################
# Defining the Output
#######################

output "[hostname]" {
	description = "Hostname"
	value       = random_string.append_string.result
}

output "[instance_name]" {
	description = "Instance name"
	value       = google_compute_instance.default.*.name[0]
}

output "[project_output]" {
	description = "Project name"
	value       = google_compute_instance.default.*.project[0]
}

output "[internal_ip_output]" {
	description = "Internal IP"
	value       = google_compute_instance.default.*.network_interface.0.network_ip
}

output "[external_ip_output]" {
	description = "External IP"
	value 		= google_compute_instance.default.*.network_interface.0.access_config.0.nat_ip
}


#######################
# Variable definitions 
#######################

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

variable "gcp_linux_user" {
	type = string
	default = "automic"
}

variable "gcp_private_key_file" {
	type = string
	default = "gcp_private_key_file"
}
variable "gcp_public_key_file" {
	type = string
	default = "gcp_public_key_file"
}

variable "remote_working_dir" {
	type = string
	default = "remote_working_dir"
}
variable "agent_port" {
	type = string
	default = "agent_port"
}
variable "ae_system_name" {
	type = string
	default = "ae_system_name"
}
variable "ae_host" {
	type = string
	default = "ae_host"
}
variable "ae_port" {
	type = string
	default = "ae_port"
}
variable "sm_port" {
	type = string
	default = "sm_port"
}
variable "sm_name" {
	type = string
	default = "sm_name"
}



