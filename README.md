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

## APIM Multi-Region Deployment

The example Terraform code in this repository deploys an Azure API Management (APIM) service in multi-region mode across two separate Virtual Networks (VNets), utilizing an internal network configuration. 

The APIM service connects to multiple OpenAI private endpoints, which are meshed into their own separate VNets. Each regional VNet pair is linked to their corresponding `privatelink.openai.azure.com` private DNS zone. 

**Important**: Do not link OpenAI private DNS zones into other region VNets as it will cause DNS resolution to break for APIM backend routing to OpenAI private endpoints.

The APIM service has its own private DNS zone `azure-api.net`. This zone will be used for frontend API calls to APIM. 

APIM is deployed in Internal network mode. This configuration does not use private endpoints. Instead, it uses a completely private network configuration by integrating APIM directly into the VNet. 

The APIM gateway in each region (including the primary region) has a regional DNS name that follows the URL pattern of `https://<service-name>-<region>-01.regional.azure-api.net`, for example `https://contoso-westus2-01.regional.azure-api.net`. Enter these corresponding regional hostnames into the private DNS zone. 

Each region has assigned private IP addresses that need to be added to the private zone. Also, include the primary host record of `https://<service-name>.azure-api.net` into the private DNS zone with both region IP addresses to take advantage of DNS round-robin allocation. 

For more information on APIM in multi-region mode, refer to the [Azure documentation](https://learn.microsoft.com/en-us/azure/api-management/api-management-howto-deploy-multi-region#about-multi-region-deployment).

![Network Diagram](<files/APIM Multi-Region.png>))