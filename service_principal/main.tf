resource "azuread_application" "application" {
  name = var.name
}

resource "azuread_service_principal" "service-principal" {
  application_id = "${azuread_application.application.application_id}"
}

data "azurerm_subscription" "current" {}

resource "azurerm_role_assignment" "service-principal-contributor" {
  scope                = "${data.azurerm_subscription.current.id}"
  role_definition_name = "Contributor"
  principal_id         = "${azuread_service_principal.service-principal.id}"
}
