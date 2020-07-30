// resource "random_string" "password" {
//     length  = 32
//     special = true
// }

// resource "azuread_application" "aksapp" {
//     name = "${var.NAME}-aksapp"
// }

// resource "azuread_service_principal" "akssp" {
//     application_id               = azuread_application.aksapp.application_id
//     app_role_assignment_required = false
// }

// resource "azuread_service_principal_password" "akssppwd" {
//     service_principal_id = azuread_service_principal.akssp.id
//     value                = random_string.password.result
//     end_date_relative    = "8760h"
//     lifecycle {
//         ignore_changes = [
//             value,
//             end_date_relative
//         ]
//     }
// }

data "azurerm_subscription" "current" {}

resource "azurerm_kubernetes_cluster" "aks" {
    name                = "${var.NAME}-aks"
    location            = var.LOCATION 
    resource_group_name = var.FUNCTION_RG
    dns_prefix          = "${var.NAME}-aks"
    kubernetes_version  = "1.17.7"

    default_node_pool {
        name                = "default"
        vm_size             = "Standard_DS2_v2"
        enable_auto_scaling = true
        min_count           = 1
        max_count           = 30
        os_disk_size_gb     = 128
    }

    identity {
        type                = "SystemAssigned"
    }
    service_principal {
        client_id     = "msi"
        client_secret = var.ACR_SP_SECRET
    }
}

data "azurerm_role_definition" "contributor" {
    name                    = "Contributor"         
}

resource "azurerm_role_assignment" "aksrole" {
    name                    = azurerm_kubernetes_cluster.aks.name
    scope                   = data.azurerm_subscription.current.id 
    role_definition_id      = "$data.azurerm_subscription.subscription.id}$data.azurerm_role_definition.contributor.id}"
    principal_id            = azurerm_kubernetes_cluster.aks.identity[0].principal_id
}
