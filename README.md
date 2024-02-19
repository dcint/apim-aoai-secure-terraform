# Terraform API Management Module

This project uses Terraform to manage API Management resources on Azure.

## Overview

This module creates and manages Azure API Management instances and associated resources. It also retrieves data from existing Azure resources like Resource Groups and Virtual Networks.

## Resources

The main resources created by this project are:

- Azure API Management instances
- Azure Cognitive Services accounts

The module also retrieves data from existing Azure resources:

- Azure Resource Groups
- Azure Virtual Networks

## Configuration

The project uses local values to define the backends for the API Management instances. These are defined in the `main.tf` file:

```terraform
locals {
  apim-backends = {
    "OpenAIEUS"  = "${data.azurerm_cognitive_account.cog-accounts["aoai-dc-eastus-test"].endpoint}"
    "OpenAIEUS2" = "${data.azurerm_cognitive_account.cog-accounts["aoai-dc-eastus2-test"].endpoint}"
  }
}