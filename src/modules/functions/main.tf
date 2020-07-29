/**
* # Module Properties
*
* This module is used to create the Azure Function application INSTANCE.  
* 
*
* function-storage-account usage and testing
*
* ```hcl
* module "functions" {
* source              = "../modules/functions"
* NAME                = var.NAME
* LOCATION            = var.LOCATION
* INSTANCE           = var.INSTANCE
* functions_RG_NAME   = azurerm_resource_group.kroger-functions.name
* FUNCTIONSAPP        = var.FUNCTIONSAPP
* }
* ```
*/

resource "azurerm_storage_account" "function-storage-account" {
  for_each                 = var.INSTANCE
  name                     = substr("${each.key}funcstorage", 0, 24)
  resource_group_name      = var.FUNCTION_RG
  location                 = var.LOCATION
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "function-deploy-container" {
    for_each                 = var.INSTANCE
    name                     = substr("${each.key}funccntr", 0, 24)
    storage_account_name     = azurerm_storage_account.function-storage-account[each.key].name
    container_access_type = "private"
}

resource "azurerm_storage_blob" "appcode" {
    for_each                  = var.INSTANCE
    name                      = "functionapp.zip"
    storage_account_name      = azurerm_storage_account.function-storage-account[each.key].name
    storage_container_name    = azurerm_storage_container.function-deploy-container[each.key].name
    type                      = "Block"
    source                    = var.FUNCTION_APP_JSON
}

resource "azurerm_function_app" "function-app" {
  for_each                  = var.INSTANCE
  name                      = "${each.key}-function"
  location                  = var.LOCATION
  resource_group_name       = var.FUNCTION_RG
  app_service_plan_id       = "var.NAME-${each.key}"
  storage_connection_string = azurerm_storage_account.function-storage-account[each.key].primary_connection_string 
  version                   = "~2"
  app_settings              = module.webapp.APPINS_IKEY
//  WEBSITE_RUN_FROM_PACKAGE     = var.FUNCTION_APP_JSON
}

resource "azurerm_app_service_plan" "function-service-plan" {
  for_each                 = var.INSTANCE
  name                     = "${each.key}-function-service-plan"
  resource_group_name      = var.FUNCTION_RG
  location                 = var.LOCATION
  sku {
    tier = "Standard"
    size = "S1"
  }
}

