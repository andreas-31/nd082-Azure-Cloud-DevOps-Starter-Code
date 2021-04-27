# Azure GUIDS
variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

# Terraform Backend in Azure
variable "tf_backend_resource_group_name" {}
variable "tf_storage_account_name" {}
variable "tf_container_name" {}
variable "tf_state_store_file_name" {}
variable "tf_access_key" {}

# Resource Group/Location
variable "location" {}
variable "resource_group" {}
variable "application_type" {}

# Tags
variable tier {}
variable deployment {}

