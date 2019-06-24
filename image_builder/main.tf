resource "azurerm_resource_group" "resource-group" {
  name     = var.resource_group_name
  location = var.location
}

data "azurerm_subscription" "current" {}

resource "azurerm_role_assignment" "resource-group-contributor" {
  # Azure Virtual Machine Image Builder Object ID (NOT Application ID)
  # Create manually following instructions in https://docs.microsoft.com/en-us/azure/virtual-machines/windows/image-builder-overview#permissions then find Object ID in Resource Groups -> YOUR_RESOURCE_GROUP_NAME -> Access control (IAM) -> Role Assignments -> Azure Virtual Machine Image Builder -> Properties
  principal_id         = "e6bfd3c4-cf63-4278-99cb-d5a1813fba05"
  role_definition_name = "Contributor"
  scope                = "${data.azurerm_subscription.current.id}/resourceGroups/${azurerm_resource_group.resource-group.name}"
}
