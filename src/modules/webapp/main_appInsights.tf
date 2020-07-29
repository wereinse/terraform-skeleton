resource azurerm_application_insights init-appIns {
  name                = var.NAME
  location            = var.LOCATION
  resource_group_name = var.APP_RG_NAME
  application_type    = "web"
}

resource azurerm_application_insights init-functionappIns {
  name                = var.NAME
  location            = var.LOCATION
  resource_group_name = var.APP_RG_NAME
  application_type    = "web"
}

output "APPINS_IKEY" {
  value       = azurerm_application_insights.init-functionappIns.instrumentation_key
  sensitive   = true
}