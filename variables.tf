variable "rg_apim_aoai" {
  description = "The name of the resource group where the API Management service will be created."
  type        = string
  default     = "rg-sephora-aoai"

}

variable "rg_vnet_aoai" {
  description = "The name of the resource group where the virtual network is located."
  type        = map(string)
  default = {
    eus = "rg-vnet-aoai-eastus"
    wus = "rg-vnet-aoai-westus"
  }
}

variable "rg_aoai_endpoints" {
  description = "The name of the resource group where the OpenAI Enpoints services are located."
  type        = string
  default     = "rg-aoai-test-eastus"

}

variable "vnet_aoai" {
  description = "The name of the virtual network where the API Management service will be deployed."
  type        = map(string)
  default = {
    eus = "vnet-aoai-eastus"
    wus = "vnet-aoai-westus"

  }
}
variable "sub_apim_aoai" {
  description = "The name of the subnet where the API Management service will be deployed."
  type        = map(string)
  default = {
    eus = "sub-private"
    wus = "sub-private"
  }

}

variable "sub_apim_aoai_westus" {
  description = "The name of the subnet where the API Management service will be deployed."
  type        = string
  default     = "sub-private"

}

variable "apim_name" {
  description = "The name of the API Management service."
  type        = string
  default     = "apim-customer"

}

variable "location" {
  description = "The location/region where the API Management service will be created."
  type        = string
  default     = "eastus"
}

variable "sku_name" {
  description = "The SKU of the API Management service."
  type        = string
  default     = "Premium_1"
}

variable "publisher_name" {
  description = "The name of the publisher of the API Management service."
  type        = string
  default     = "Customer"
}

variable "publisher_email" {
  description = "The email of the publisher of the API Management service."
  type        = string
  default     = "david@cintron.io"
}

variable "zones" {
  description = "The availability zones where the API Management service will be deployed."
  type        = list(string)
  default     = null

}