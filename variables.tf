variable "prefix" {
  type        = "string"
  description = "Specify the prefix for resource names"
  default     = "AzurePipelines"
}

# Not allowed to compose like ${var.prefix}-Windows here?
variable "win_prefix" {
  default = "AzurePipelines-Windows"
}

variable "resource_group" {
  type        = "string"
  description = "Specify the resource group if it already exists"
  default     = "AzurePipelines-ResourceGroup"
}

variable "location" {
  type        = "string"
  description = "Specify the location where the resources should be created"
  default     = "WestUS"
}

# https://docs.microsoft.com/en-us/azure/virtual-machines/windows/sizes
# az vm list-skus --location WestUS --size Standard_B --output table
variable "size" {
  type        = "string"
  description = "Specify the instance size for the VM"
  default     = "Standard_B1ms"
}

variable "hostname" {
  type        = "string"
  description = "Specify the computer name for the VM. Cannot be more than 15 characters long, be entirely numeric, or contain the following characters: ` ~ ! @ # $ % ^ & * ( ) = + _ [ ] { } \\ | ; : . ' \" , < > / ?"
}

variable "admin_username" {
  type        = "string"
  description = "Specify the admin username for the VM"
}

variable "admin_password" {
  type        = "string"
  description = "Specify the admin password for the VM"
}

# The url of the Azure DevOps Organization https://dev.azure.com/{ORGANIZATION}
variable "url" {
  type        = "string"
  description = "Specify the Azure DevOps url e.g. https://dev.azure.com/{ORGANIZATION}"
}

# Create via https://dev.azure.com/{ORGANIZATION}/_usersSettings/tokens
variable "token" {
  type        = "string"
  description = "Provide a Personal Access Token (PAT) for Azure DevOps"
}

# Create via https://dev.azure.com/{ORGANIZATION}/_settings/agentpools unless using Default pool
variable "pool" {
  type        = "string"
  description = "Specify the name of the agent pool - must exist before"
  default     = "Default"
}

variable "agent" {
  type        = "string"
  description = "Specify the name of the build agent"
  default     = "Self-Hosted Agent"
}
