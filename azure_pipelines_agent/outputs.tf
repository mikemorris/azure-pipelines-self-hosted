output "install_windows_agent_path" {
  value       = azurerm_storage_blob.install_windows_agent_script.source
  description = "The local file path of the agent install script."
}

output "install_windows_agent_url" {
  value       = azurerm_storage_blob.install_windows_agent_script.url
  description = "The remote path of the agent install script."
}

output "install_windows_agent_name" {
  value       = azurerm_storage_blob.install_windows_agent_script.name
  description = "The remote name of the agent install script."
}
