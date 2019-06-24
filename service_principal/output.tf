output "subscription-id" {
  value = "${data.azurerm_subscription.current.id}"
}

output "serivce-principal-id" {
  value = "${azuread_service_principal.service-principal.id}"
}
