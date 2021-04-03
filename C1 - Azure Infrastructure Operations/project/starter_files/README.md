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
### Output
**Your words here**

