// This is the main.tf file for the API Management module
// Data sources for the resource groups and virtual network

data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "rg-apim-aoai" {
  name = var.rg_apim_aoai
}
data "azurerm_resource_group" "rg-vnet-aoai" {
  for_each = var.rg_vnet_aoai
  name     = each.value

}

data "azurerm_virtual_network" "vnet-aoai" {
  for_each            = var.vnet_aoai
  name                = each.value
  resource_group_name = data.azurerm_resource_group.rg-vnet-aoai[each.key].name

}
data "azurerm_subnet" "sub-apim-aoai" {
  for_each             = var.sub_apim_aoai
  name                 = each.value
  resource_group_name  = data.azurerm_resource_group.rg-vnet-aoai[each.key].name
  virtual_network_name = data.azurerm_virtual_network.vnet-aoai[each.key].name
}
data "azurerm_resource_group" "rg-aoai-endpoints" {
  name = var.rg_aoai_endpoints

}

// Local for openai cognitive accounts and their respective locations
locals {
  cog_accounts = {
    "aoai-dc-eastus-test" = "eastus"
    "aoai-dc-westus-test" = "westus"
  }
}

data "azurerm_cognitive_account" "cog-accounts" {
  for_each            = local.cog_accounts
  name                = each.key
  resource_group_name = data.azurerm_resource_group.rg-aoai-endpoints.name
}

// API Management service and its respective resources
locals {
  public_ip_names = [
    "pip-apim-sep-eus",
    "pip-apim-sep-wus"
  ]
  domain_name_labels = [
    "apim-aoai-sep-eus",
    "apim-aoai-sep-wus"
  ]
}
resource "azurerm_public_ip" "pip-apim" {
  name                = local.public_ip_names[0]
  location            = data.azurerm_resource_group.rg-vnet-aoai["eus"].location
  resource_group_name = data.azurerm_resource_group.rg-vnet-aoai["eus"].name
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = local.domain_name_labels[0]
}

resource "azurerm_public_ip" "pip-apim-westus" {
  name                = local.public_ip_names[1]
  location            = data.azurerm_resource_group.rg-vnet-aoai["wus"].location
  resource_group_name = data.azurerm_resource_group.rg-vnet-aoai["wus"].name
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = local.domain_name_labels[1]
}
resource "azurerm_api_management" "apim-aoai" {
  name                 = var.apim_name
  location             = var.location
  resource_group_name  = data.azurerm_resource_group.rg-apim-aoai.name
  publisher_name       = var.publisher_name
  publisher_email      = var.publisher_email
  public_ip_address_id = azurerm_public_ip.pip-apim.id
  zones                = var.zones

  identity {
    type = "SystemAssigned"

  }

  sku_name = var.sku_name

  virtual_network_type = "Internal"
  virtual_network_configuration {
    subnet_id = data.azurerm_subnet.sub-apim-aoai["eus"].id
  }
  additional_location {
    location             = data.azurerm_resource_group.rg-vnet-aoai["wus"].location
    public_ip_address_id = azurerm_public_ip.pip-apim-westus.id
    zones                = var.zones
    virtual_network_configuration {
      subnet_id = data.azurerm_subnet.sub-apim-aoai["wus"].id
    }
  }
}

locals {
  apim-backends = {
    "OpenAIEUS" = "${data.azurerm_cognitive_account.cog-accounts["aoai-dc-eastus-test"].endpoint}"
    "OpenAIWUS" = "${data.azurerm_cognitive_account.cog-accounts["aoai-dc-westus-test"].endpoint}"
  }
}

resource "azurerm_api_management_backend" "apim-backend" {
  for_each            = local.apim-backends
  name                = each.key
  resource_group_name = data.azurerm_resource_group.rg-apim-aoai.name
  api_management_name = azurerm_api_management.apim-aoai.name
  url                 = each.value
  protocol            = "http"
  title               = "AOAI Backend"
  description         = "Backend for AOAI API Management"
}

resource "azurerm_api_management_api" "apim-api" {
  name                = "aoai-api"
  resource_group_name = data.azurerm_resource_group.rg-apim-aoai.name
  api_management_name = azurerm_api_management.apim-aoai.name
  revision            = "1"
  display_name        = "AOAI API"
  path                = "openai"
  protocols           = ["https"]

  import {
    content_format = "openapi-link"
    content_value  = "https://raw.githubusercontent.com/Azure/azure-rest-api-specs/main/specification/cognitiveservices/data-plane/AzureOpenAI/inference/stable/2023-05-15/inference.json"
  }
}

// Policy for the API Management service
resource "azurerm_api_management_api_policy" "apim-policy" {
  api_name            = azurerm_api_management_api.apim-api.name
  api_management_name = azurerm_api_management_api.apim-api.api_management_name
  resource_group_name = data.azurerm_resource_group.rg-apim-aoai.name

  xml_content = file("files/apim-policy.xml")
}

// Local variables for the private DNS zone and the private DNS A records
locals {
  create_private_dns_zone = true
  private_dns_zones = [
    "azure-api.net"
  ]
}

data "azurerm_private_dns_zone" "private-dns-zone" {
  for_each            = local.create_private_dns_zone ? toset(local.private_dns_zones) : toset([])
  name                = each.value
  resource_group_name = data.azurerm_resource_group.rg-vnet-aoai["eus"].name
}
locals {
  create_private_dns_a_records = true
  private_dns_a_records = [
    var.apim_name,
    "${var.apim_name}.developer",
    "${var.apim_name}.management",
  ]
}

resource "azurerm_private_dns_a_record" "a-record" {
  for_each            = local.create_private_dns_a_records ? toset(local.private_dns_a_records) : toset([])
  name                = each.value
  zone_name           = data.azurerm_private_dns_zone.private-dns-zone["azure-api.net"].name
  resource_group_name = data.azurerm_resource_group.rg-vnet-aoai["eus"].name
  ttl                 = 300
  records             = [azurerm_api_management.apim-aoai.private_ip_addresses[0]]

  depends_on = [azurerm_api_management.apim-aoai]
}

// Role assignment for the API Management service to access the OpenAI Cognitive Services
resource "azurerm_role_assignment" "rbac-aoai" {
  for_each             = local.cog_accounts
  scope                = data.azurerm_cognitive_account.cog-accounts[each.key].id
  role_definition_name = "Cognitive Services OpenAI User"
  principal_id         = azurerm_api_management.apim-aoai.identity[0].principal_id
}