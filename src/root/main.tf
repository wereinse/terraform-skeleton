/**
* # Parent Template Properties
*
* This is the parent Terraform Template used to call the component modules to create the infrastructure and deploy the application.
*
* The only resources created in the template are the resource groups that each Service will go into. It is advised to create a terraform.tfvars file to assign values to the variables in the `variables.tf` file.
*
* To keep sensitive keys from being stored on disk or source control you can set local environment variables that start with **NameOfVariable**. This can be used with the Terraform Service Principal Variables
*
* tfstate usage (not real values)
*
* ```shell
* export TF_SUB_ID="gy6tgh5t-9876-3uud-87y3-r5ygytd6uuyr"
* export TF_TENANT_ID="frf34ft5-gtfv-wr34-343fw-hfgtry657uk8"
* export TF_CLIENT_ID="ju76y5h8-98uh-oin8-n7ui-ger43k87d5nl"
* export TF_CLIENT_SECRET="kjbh89098hhiuovvdh6j8uiop="
* ```
*/

provider "azurerm" {
  version = "2.0.0"
  use_msi = true
  features {}

  subscription_id = var.TF_SUB_ID
  client_id       = var.TF_CLIENT_ID
  client_secret   = var.TF_CLIENT_SECRET
  tenant_id       = var.TF_TENANT_ID
}

provider "azuread" {
  subscription_id = var.TF_SUB_ID
  client_id       = var.TF_CLIENT_ID
  client_secret   = var.TF_CLIENT_SECRET
  tenant_id       = var.TF_TENANT_ID
}

resource "azurerm_resource_group" "function-app" {
  name     = "${var.NAME}-FUNCTION-RG"
  location = var.LOCATION
}


module "function" {
  source              = "../modules/functions"
  NAME                = var.NAME
  INSTANCE            = var.INSTANCE
  LOCATION            = var.LOCATION
  FUNCTION_RG         = azurerm_resource_group.function-app.name
  ACR_SP_ID           = var.ACR_SP_ID
  ACR_SP_SECRET       = var.ACR_SP_SECRET
}