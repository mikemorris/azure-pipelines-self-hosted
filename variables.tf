variable "admin_username" {
  type        = "string"
  description = "Specify the admin username for the VM"
}

variable "admin_password" {
  type        = "string"
  description = "Specify the admin password for the VM"
}

variable "azure_devops_url" {
  type        = "string"
  description = "Specify the Azure DevOps url e.g. https://dev.azure.com/{ORGANIZATION}"
}

# Create via https://dev.azure.com/{ORGANIZATION}/_usersSettings/tokens
variable "token" {
  type        = "string"
  description = "Provide a Personal Access Token (PAT) for Azure DevOps"
}
