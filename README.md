# Terraform API Management Module

This project uses Terraform to manage API Management resources on Azure.

## Overview

This module creates and manages Azure API Management Multi-Region instances and associated resources. It also retrieves data from existing Azure resources like Resource Groups, Virtual Networks, and OpenAI endpoints. It provides load balancing to multiple OpenAI private endpoints in multiple regions. 

## Resources

The main resources created by this project are:

- Azure API Management instances

The module also retrieves data from existing Azure resources:

- Azure Resource Groups
- Azure Virtual Networks
- Azure Cognitive OpenAI Accounts
- Private DNS Zone

## Inputs

The module requires the following inputs:

- `rg-apim-aoai`: The name of the resource group where the API Management instance will be created.
- `rg-vnet-aoai`: The name of the resource group where the Virtual Network is located.
- `rg-aoai-endpoints`: The name of the resource group where the Cognitive Services accounts are located.
- `vnet-aoai`: The name of the Virtual Network that the API Management instance will be connected to.
- `sub-apim-aoai`: The name of the subnet in the Virtual Network that the API Management instance will be connected to.
- `apim_name`: The name of the API Management instance.
- `location`: The Azure region where the API Management instance will be created.
- `sku_name`: The SKU name of the API Management instance.
- `publisher_name`: The name of the publisher.
- `publisher_email`: The email of the publisher.
- `zones`: The zones where the API Management should be created. This is optional and defaults to an empty list if not provided.

## Usage

To use this module, you need to have Terraform installed. You can then initialize the project with `terraform init` and apply the configuration with `terraform apply`.

Please ensure you have the necessary Azure credentials set up in your environment.

![Network Diagram](<files/APIM Multi-Region.png>))