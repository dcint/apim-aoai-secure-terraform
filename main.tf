module "apim" {
  source               = "./modules/apim"
  rg-apim-aoai         = var.rg-apim-aoai
  rg-vnet-aoai         = var.rg-vnet-aoai
  rg-vnet-aoai-westus  = var.rg-vnet-aoai-westus
  rg-aoai-endpoints    = var.rg-aoai-endpoints
  vnet-aoai            = var.vnet-aoai
  vnet-aoai-westus     = var.vnet-aoai-westus
  sub-apim-aoai        = var.sub-apim-aoai
  sub-apim-aoai-westus = var.sub-apim-aoai-westus
  apim_name            = var.apim_name
  location             = var.location
  sku_name             = var.sku_name
  publisher_name       = var.publisher_name
  publisher_email      = var.publisher_email
  zones                = var.zones

}
