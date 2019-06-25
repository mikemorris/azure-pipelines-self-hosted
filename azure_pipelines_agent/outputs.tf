output "install_windows_agent_path" {
  value       = azurerm_storage_blob.install_windows_agent_blob.source
  description = "The local file path of the agent install script."
}

output "install_windows_agent_url" {
  value       = azurerm_storage_blob.install_windows_agent_blob.url
  description = "The remote path of the agent install script."
}

output "install_windows_agent_name" {
  value       = azurerm_storage_blob.install_windows_agent_blob.name
  description = "The remote name of the agent install script."
}
