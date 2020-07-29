data "azurerm_subscription" "current" {}

resource "azurerm_kubernetes_cluster" "aks" {
//  for_each                 = var.INSTANCE 
//  name                     = substr("${each.key}funcstorage", 0, 24)
  name                     = "aksmsi"
  resource_group_name      = var.FUNCTION_RG
  location                 = var.LOCATION
  dns_prefix               = var.NAME
  
  identity {
    type                   = "SystemAssigned"
  }

  service_principal {
    client_id              = var.ACR_SP_ID
    client_secret          = var.ACR_SP_SECRET
  }   

  // linux_profile {
  //   admin_username              = "ubuntu"
  //   ssh_key {
  //     ssh_key   = "~/.ssh/id_rsa.pub"
  //   }
  // }

identity {
  type          = "SystemAssigned"
  principal_id  = var.ACR_SP_ID
  tenant_id     = var.TF_TENANT_ID
  }


default_node_pool {
  name = "default"
  node_count = 1
  vm_size = "Standard_DS1_v2"
//  os_type = "Linux"
  os_disk_size_gb = "30"
  }
}