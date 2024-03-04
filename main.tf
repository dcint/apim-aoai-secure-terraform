module "apim-multi-region" {
  source            = "./modules/apim-multi-region"
  rg_apim_aoai      = var.rg_apim_aoai
  rg_vnet_aoai      = var.rg_vnet_aoai
  rg_aoai_endpoints = var.rg_aoai_endpoints
  vnet_aoai         = var.vnet_aoai
  sub_apim_aoai     = var.sub_apim_aoai
  apim_name         = var.apim_name
  location          = var.location
  sku_name          = var.sku_name
  publisher_name    = var.publisher_name
  publisher_email   = var.publisher_email
  zones             = var.zones

}
