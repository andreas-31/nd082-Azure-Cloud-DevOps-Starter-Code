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
1. Apply Azure policies to enforce that tags are applied to resources (if they support tagging)
Azure offers managed policies for tag compliance: [Assign policies for tag compliance](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/tag-policies)
In order to ensure that all indexed resources in the subscription have tags and deployment is denied if they do not, the following two policies are applied on Azure CLI:
```
az provider register --namespace 'Microsoft.PolicyInsights'

az policy assignment create --name 'Enforce tagging of indexed resources' --display-name 'Policy ensures that only indexed resources with applied tags are deployed' --policy /providers/Microsoft.Authorization/policyDefinitions/871b6d14-10aa-478d-b590-94f262ecfa99


https://github.com/Azure/azure-policy/blob/master/built-in-policies/policyDefinitions/Tags/RequireTag_Deny.json
```

### Output
**Your words here**

