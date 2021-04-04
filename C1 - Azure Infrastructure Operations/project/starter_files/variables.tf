variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
  default = "FirstTerraform"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
  default = "East US"
}

variable "username" {
  description = "Name of user for login"
  default = "sportler"
}

variable "password" {
  description = "Password of user for login"
  default = "aZ8_99-WpQ4_8000_4000"
}
