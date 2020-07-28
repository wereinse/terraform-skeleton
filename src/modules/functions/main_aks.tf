resource "azurerm_kubernetes_cluster" "aks" {
//  for_each                 = var.INSTANCE 
//  name                     = substr("${each.key}funcstorage", 0, 24)
  name                     = "aksmsi"
  resource_group_name      = var.FUNCTION_RG
  location                 = var.LOCATION
  dns_prefix               = "var.DNS_PREFIX"

  linux_profile {
    admin_username = "ubuntu"
  }

  azure_active_directory {
    managed       = "true"
  }

  role_based_access_control {
    enabled       = "true"
  }

//   tags {
//     Environment = "Development"
//   }
}
// output "id" {
//     value = azurerm_kubernetes_cluster.aks.id
// }

// output "admin-group-object-ids" {
//     value = azurerm_kubernetes_cluster.aks.admin_group_object_ids
// }

// output "client-app-id" {
//     value = azurerm_kubernetes_cluster.aks.client_app_id
// }

// output "server-app-id" {
//     value = azurerm_kubernetes_cluster.aks.server_app_id
// }

// output "kube_config" {
//   value = azurerm_kubernetes_cluster.aks.kube_config_raw
// }

// output "client_key" {
//   value = azurerm_kubernetes_cluster.aks.kube_config.0.client_key
// }

// output "client_certificate" {
//   value = azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate
// }

// output "cluster_ca_certificate" {
//   value = azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate
// }

// output "host" {
//   value = azurerm_kubernetes_cluster.aks.kube_config.0.host
// }
// }