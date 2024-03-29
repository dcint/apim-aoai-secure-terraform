variable "rg-apim-aoai" {
  description = "The name of the resource group where the API Management service will be created."
  type        = string

}

variable "rg-vnet-aoai" {
  description = "The name of the resource group where the virtual network is located."
  type        = string

}

variable "rg-aoai-endpoints" {
  description = "The name of the resource group where the OpenAI Enpoints services are located."
  type        = string

}

variable "vnet-aoai" {
  description = "The name of the virtual network where the API Management service will be deployed."
  type        = string

}

variable "sub-apim-aoai" {
  description = "The name of the subnet where the API Management service will be deployed."
  type        = string

}

variable "apim_name" {
  description = "The name of the API Management service."
  type        = string

}

variable "location" {
  description = "The location/region where the API Management service will be created."
  type        = string
}

variable "sku_name" {
  description = "The SKU of the API Management service."
  type        = string
}

variable "publisher_name" {
  description = "The name of the publisher of the API Management service."
  type        = string
}

variable "publisher_email" {
  description = "The email of the publisher of the API Management service."
  type        = string
}

variable "zones" {
  description = "The availability zones where the API Management service will be deployed."
  type        = list(string)

}


