# Azure Infrastructure Operations Project: Deploying a scalable IaaS web server in Azure

### Introduction
For this project, you will write a Packer template and a Terraform template to deploy a customizable, scalable web server in Azure.

### Getting Started
1. Clone this repository

2. Create your infrastructure as code

3. Update this README to reflect how someone would use your code.

### Dependencies
1. Create an [Azure Account](https://portal.azure.com) 
2. Install the [Azure command line interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
3. Install [Packer](https://www.packer.io/downloads)
4. Install [Terraform](https://www.terraform.io/downloads.html)

### Instructions
#### Step 1: Tagging Policy
Enforce resource tagging by applying a custom policy for tagging to enforce that tags are applied to resources with resource types that support tags and locations
The mode of the policy is set to "indexed" which evaluates only resource types that support tags and locations. In order to ensure that all indexed resources in the subscription have tags and deployment is denied if they do not, the following Policy Definition and Policy Assignment are applied in Azure CLI:
```bash
# Create the Policy Definition (Subscription scope) 
az policy definition create --name "RequireTagsOnIndexedResources" --display-name "Ensure all indexed resources are tagged" --description "Policy that ensures all indexed resources in the subscription have tags and deny deployment if they do not." --rules RequireTagsOnIndexedResources.Rules.json --mode indexed
 
# Create the Policy Assignment 
# Set the scope to a subscription
# Replace all {SUBSCRIPTION ID} placeholders with an actual Azure subscription ID
az policy assignment create --name "tagging-policy" --display-name "Ensure all indexed resources are tagged Assignment" --scope /subscriptions/{SUBSCRIPTION ID} --policy /subscriptions/{SUBSCRIPTION ID}/providers/Microsoft.Authorization/policyDefinitions/RequireTagsOnIndexedResources

# Optional for testing: create a virtual machine without tags and see how it fails with error code RequestDisallowedByPolicy
az vm create --resource-group udacity-cli-rg --name udacity-cli-vm --image UbuntuLTS --generate-ssh-keys --output json --verbose --admin-username udacity

# Optional for testing: create a virtual machine with tags and see how creation of virtual machine succeeds
az vm create --resource-group udacity-cli-rg --name udacity-cli-vm --image UbuntuLTS --generate-ssh-keys --output json --verbose --admin-username udacity --tags udacity=project
```
#### Step 2: Packer Template
The image for the virtual machine with included web server and web app are built with Packer.
```bash
# Packer command to create image for virtual machine in Azure
packer build -var 'client_id={CLIENT ID}' -var 'client_secret={CLIENT SECRET}' -var 'subscription_id={SUBSCRIPTION ID}' server.json
```
In order to authenticate to your subscription replace the following values with those applicable to your subscription and service principal:
1. {CLIENT ID}
2. {CLIENT SECRET}
3. {SUBSCRIPTION ID}

Please check the following how-to in the Azure documentation to create a service principal and get the required ID values:

[How to: Use the portal to create an Azure AD application and service principal that can access resources](https://docs.microsoft.com/en-us/azure/active-directory/develop/howto-create-service-principal-portal)

#### Step 3: Terraform Template
Commands for provisioning the infrastructure in the Azure cloud with Terraform:
```:bash
# Initialize Terraform in the folder containing the file donloaded from this Git repository
terraform init

# Initial deployment and modifications to existing deployment
terraform plan -out solution.plan
terraform apply solution.plan

# Removal of all resources provisioned in earlier steps
terraform destroy
```
Default values have been set in the file variables.tf for the following variables:
- prefix
- number_of_virtual_machines
- location
- resource_group_name
- packer_image_name
- application_port
- admin_user
- admin_ssh_public_key_file

Customization of deployment including number of virtual machines: each variable can be set to custom value by using of the following methods:
1. Use a custom .tfvars file
```:bash
# Example for changing the number of to be provisioned virtual machines to 3
# by using a customized .tfvars file.
echo "number_of_virtual_machines = 3" > custom.tfvars
terraform plan -out solution.plan -var-file custom.tfvars
```
2. Provide variable and value on the command line when executing the terraform apply command
```:bash
# Example for changing the number of to be provisioned virtual machines to 3
# by supplying the customized value on the command line.
terraform plan -out solution.plan -var='number_of_virtual_machines=3'
```
3. Change default values directly in the file variables.tf

### Output
The Terraform apply command outputs these values after successfully provisioning the resources:
- public_IP_Load_Balancer: Public HTTP service IP address of the load balancer in front of the webservers.
- network_Interface_Private_IP: Private IP addresses of the VM network interfaces, e.g. when 3 virtual machines are provisioned, 3 private IP addresses will be displayed.

