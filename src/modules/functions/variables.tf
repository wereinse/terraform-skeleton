variable "NAME" {
  description = "The prefix which should be used for all resources in this example"
  type        = string
}

variable "FUNCTION_RG" {
  description = "The Azure Resource Group the functions should be added to"
  type        = string
}

variable "LOCATION" {
  description = "The Azure Region in which all resources in this example should be created."
  type        = string
}
variable "INSTANCE" {
  description = "Map of the environment name and the helium application language to use i.e {myinstance1 = boh, myinstance2 = ibmivcount}"
  type        = map(string)
}
variable "FUNCTION_APP_JSON" {
  description = "Zip file containing the code for the Azure Function"
  type        = string
}

variable "SSH_PUBLIC_KEY" {
  description = "Public key to exchange"
default     = "~/.ssh/id_rsa.pub"
}

variable "ACR_SP_ID" {
  type        = string
  description = "The ACR Service Principal"
}

variable "ACR_SP_SECRET" {
  type        = string
  description = "The ACR Service Principal secret"
}

variable "AKS_APP_SETTINGS" {
  type        = string
  description = "The AKS Applications settings ID"
}
