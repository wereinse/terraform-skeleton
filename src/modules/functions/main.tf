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

resource "random_id" "funcstorage" {
  byte_length = 6
  keepers = {
    rg_id = "${var.FUNCTION_RG}"
  }
}

resource "azurerm_kubernetes_cluster" "aks" {
  for_each                 = var.INSTANCE
  name                     = substr("${each.key}funcstorage", 0, 24)
  resource_group_name      = var.FUNCTION_RG
  location                 = var.LOCATION
  dns_prefix               = var.NAME 
  
  linux_profile {
    admin_username = "ubuntu"

    ssh_key {
      key_data = var.SSH_PUBLIC_KEY
    }
  }

  default_node_pool {
    name = "default"
//    count = 1
    vm_size = "Standard_DS1_v2"
//    os_type = "Linux"
    os_disk_size_gb = "30"
  }

  service_principal {
    client_id = var.ACR_SP_ID
    client_secret = var.ACR_SP_SECRET
  }
}

output "id" {
    value = "${azurerm_kubernetes_cluster.aks.id}"
}

output "kube_config" {
  value = "${azurerm_kubernetes_cluster.aks.kube_config_raw}"
}

output "client_key" {
  value = "${azurerm_kubernetes_cluster.aks.kube_config.0.client_key}"
}

output "client_certificate" {
  value = "${azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate}"
}

output "cluster_ca_certificate" {
  value = "${azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate}"
}

output "host" {
  value = "${azurerm_kubernetes_cluster.aks.kube_config.0.host}"
}

resource "azurerm_storage_account" "function-storage-account" {
  for_each                 = var.INSTANCE
  name                     = substr("${each.key}.random_id.funcstorage.id", 0, 24)
  resource_group_name      = var.FUNCTION_RG
  location                 = var.LOCATION
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_function_app" "function-app" {
  for_each                  = var.INSTANCE
  name                      = "${each.key}-funcapp.random_id.funcstorage.id"
  location                  = var.LOCATION
  resource_group_name       = var.FUNCTION_RG
  app_service_plan_id       = module.web.azurerm_app_service_plan.init-functionapp-plan.id 
  storage_connection_string = azurerm_storage_account.function-storage-account[each.key].primary_connection_string 
  version                   = "~2"
  app_settings              = var.AKS_APP_SETTINGS
  WEBSITE_RUN_FROM_PACKAGE  = var.FUNCTION_APP_JSON
}
