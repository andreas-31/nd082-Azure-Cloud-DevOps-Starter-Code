variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
  default     = "udacity-project1"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
  default     = "East US"
}

variable "resource_group_name" {
  description = "The name of the resource group in which the resources are created"
  default     = "udacity-cli-rg"
}
