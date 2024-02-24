# Terraform API Management Module

This project uses Terraform to manage highly available API Management resources, with a backend configuration designed for scalability and resilience with OpenAI.

## Overview

This module is responsible for creating and managing Azure API Management Multi-Region instances along with their associated resources. Existing Azure resources such as Resource Groups, Virtual Networks, and OpenAI endpoints are accessed for data retrieval. Load balancing across multiple OpenAI private endpoints in various regions is another key feature provided by this module.

## Resources

The main resources created by this project are:

## Deployed Resources

Based on the provided Terraform code, this module deploys the following resources:

- **Azure API Management (APIM) Service (`azurerm_api_management`)**: Serving as the main resource, the APIM Service is deployed with a system-assigned managed identity and configured to use an internal virtual network. An additional location is specified to ensure high availability.

- **Public IP Addresses (`azurerm_public_ip`)**: These are used by the APIM service. One is used for the primary location and another for the additional location.

- **API Management Backends (`azurerm_api_management_backend`)**: These are the backends that the APIM service will forward requests to. In this case, it's set up to forward requests to two OpenAI endpoints, one in East US and another in West US.

- **Local Values (`locals`)**: These are not resources themselves, but they define a map of backend endpoints for the APIM service. The keys are the names of the backends and the values are the URLs of the OpenAI endpoints.

Please note that the actual resources deployed might be more than these, as the provided code is only a part of the whole Terraform module.

This module also retrieves data from the following existing Azure resources:

- **Azure Resource Groups**
- **Azure Virtual Networks**
- **Azure Cognitive OpenAI Accounts**
- **Private DNS Zone**

## Inputs

The module requires the following inputs:

- **`source`**: The path to the module that should be deployed. In this case, it's set to `./modules/apim-multi-region`.

- **`rg-apim-aoai`**: The name of the resource group for the Azure API Management (APIM) service.

- **`rg-vnet-aoai`**: The name of the resource group for the virtual network in the primary location.

- **`rg-vnet-aoai-westus`**: The name of the resource group for the virtual network in the West US location.

- **`rg-aoai-endpoints`**: The name of the resource group for the OpenAI endpoints.

- **`vnet-aoai`**: The name of the virtual network in the primary location.

- **`vnet-aoai-westus`**: The name of the virtual network in the West US location.

- **`sub-apim-aoai`**: The name of the subnet for the APIM service in the primary location.

- **`sub-apim-aoai-westus`**: The name of the subnet for the APIM service in the West US location.

- **`apim_name`**: The name of the APIM service.

- **`location`**: The primary location for the deployment.

- **`sku_name`**: The SKU name for the APIM service.

- **`publisher_name`**: The name of the publisher for the APIM service.

- **`publisher_email`**: The email of the publisher for the APIM service.

- **`zones`**: The availability zones for the deployment.

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


## System-Assigned Managed Identity

Azure API Management (APIM) uses a system-assigned managed identity to authenticate to and gain access to the OpenAI endpoint. A system-assigned managed identity is an Entra ID identity that is automatically managed by Azure. 

When a system-assigned managed identity is enabled on APIM, Azure creates an identity for the instance in the Entra ID tenant that's trusted by the subscription of the instance. Azure automatically assigns this identity the correct permissions to access the OpenAI endpoint.

This approach has several benefits:

- **Security**: The credentials used by APIM to authenticate to the OpenAI endpoint are managed by Azure. You don't need to manage these credentials yourself, reducing the risk of credential leakage.
- **Simplicity**: You don't need to create an identity yourself. Azure automatically manages the lifecycle of the system-assigned identity.
- **Access Control**: You can use Azure role-based access control (RBAC) to precisely control the access that APIM has to the OpenAI endpoint.

## Network Diagram for APIM Multi-Region Deployment with OpenAI Private Endpoints 

![Network Diagram](<files/APIM Multi-Region.png>)