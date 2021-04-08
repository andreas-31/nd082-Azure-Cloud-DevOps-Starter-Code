variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
  default     = "udacity-project1"
}

variable "number_of_virtual_machines" {
  description = "The number of virtual machines that will be instantiated and will be part of the availability set."
  default     = 2
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
  default     = "East US"
}

variable "resource_group_name" {
  description = "The name of the resource group in which the resources are created"
  default     = "udacity-cli-rg"
}

variable "packer_image_name" {
  description = "The name of the Packer image to be used for the virtual machines running the web app"
  default     = "UdacityWebServerPackerImage"
}

variable "application_port" {
  description = "The port that you want to expose to the external load balancer"
  default     = 80
}

variable "admin_user" {
  description = "Default username for admin user"
  default     = "adminuser"
}

variable "admin_ssh_public_key_file" {
  description = "Path to SSH public key file holding the key data that will be added to virtual machine's authorized_keys file for the admin user to login via SSH."
  default     = "~/.ssh/id_rsa.pub"
}
