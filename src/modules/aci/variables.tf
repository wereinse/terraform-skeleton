variable "NAME" {
  description = "The prefix which should be used for all resources in this example"
  type        = string
}

variable "ACI_RG_NAME" {
  description = "The Azure Resource Group the resource should be added to"
  type        = string
}

variable "LOCATION" {
  description = "The Azure Region in which all resources in this example should be created."
  type        = string
}

variable "CONTAINER_FILE_NAME" {
  description = "The file name to pass to the container command."
  type        = string
}

variable "APP_SERVICE_DONE" {
  description = "App Service dependency complete"
  type        = bool
}

variable "REPO" {
  description = "Docker image repo to use"
  type        = string
}

variable "INSTANCE" {
  type = map(string)
}

variable "IMAGE_NAME" {
  type        = string
  description = "The image to pull from the REPO"
}