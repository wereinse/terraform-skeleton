data "azurerm_client_config" "tfstatecurrent" {}

resource "random_id" "tfstatestoracct" {
  keepers = {
    rg_id = "${var.TFSTATE_RG_NAME}"
  }
}

resource "azurerm_storage_account" "tfstate" {
  name                      = "${var.NAME}${random_id.tfstatestoracct.id.hex}"
  resource_group_name       = var.TFSTATE_RG_NAME
  location                  = var.LOCATION
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true
}

output "tfstate_primary_key" {
  value       = azurerm_storage_account.tfstate.primary_access_key
  sensitive   = true
  description = "The primary read Only key for the tfstate storage account.  This is used to secure a valid tfstate file"
}

output "tfstate_secondary_key" {
  value       = azurerm_storage_account.tfstate.secondary_access_key
  sensitive   = true
  description = "The secondary read Only key for the tfstate storage account.  This is used to secure a valid tfstate file"
}

output "tfstate_primary_connection_string" {
  value       = azurerm_storage_account.tfstate.primary_connection_string
  sensitive   = true
  description = "The read Only key for connecting to the tfstate storage account.  This is used to secure a valid tfstate file"
}

output "tfstate_primary_blob_connection_string" {
  value       = azurerm_storage_account.tfstate.primary_blob_connection_string
  sensitive   = true
  description = "The read Only key for connecting to the blob in the tfstate storage account.  This is used to secure a valid tfstate file"
}

resource "azurerm_storage_container" "tfstate" {
  name                   = "${var.NAME}-tf-state"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "tfstate" {
  depends_on             = [ var.ACI_DONE ]
  name                   = "terraform.tfstate"
  storage_account_name   = azurerm_storage_account.tfstate.name
  storage_container_name = azurerm_storage_container.tfstate.name
  type                   = "Block"
  source                 = "terraform.tfstate"
}

terraform {
  backend "azurerm" {
    resource_group_name  = var.TFSTATE_RG_NAME
    storage_account_name = azurerm_storage_account.tfstate.name
    container_name       = azurerm_storage_container.tfstate.name
    key                  = "prod.terraform.tfstate"
    primary_access_key   = azurerm_storage_account.tfstate.primary_access_key
  }
}
