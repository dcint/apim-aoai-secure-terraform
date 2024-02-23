variable "rg-apim-aoai" {
  description = "The name of the resource group where the API Management service will be created."
  type        = string
  default     = "rg-sephora-aoai"

}

variable "rg-vnet-aoai" {
  description = "The name of the resource group where the virtual network is located."
  type        = string
  default     = "rg-vnet-aoai-eastus"

}

variable "rg-vnet-aoai-westus" {
  description = "The name of the resource group where the westus virtual network is located."
  type        = string
  default     = "rg-vnet-aoai-westus"

}

variable "rg-aoai-endpoints" {
  description = "The name of the resource group where the OpenAI Enpoints services are located."
  type        = string
  default     = "rg-aoai-test-eastus"

}

variable "vnet-aoai" {
  description = "The name of the virtual network where the API Management service will be deployed."
  type        = string
  default     = "vnet-aoai-eastus"

}

variable "vnet-aoai-westus" {
  description = "The name of the virtual network where the second region API Management service will be deployed."
  type        = string
  default     = "vnet-aoai-westus"

}

variable "sub-apim-aoai" {
  description = "The name of the subnet where the API Management service will be deployed."
  type        = string
  default     = "sub-private"

}

variable "sub-apim-aoai-westus" {
  description = "The name of the subnet where the API Management service will be deployed."
  type        = string
  default     = "sub-private"

}

variable "apim_name" {
  description = "The name of the API Management service."
  type        = string
  default     = "apim-sephora"

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
  default     = "Sephora"
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



