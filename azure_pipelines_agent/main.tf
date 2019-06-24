resource "azurerm_resource_group" "main" {
  name     = "${var.resource_group}"
  location = "${var.location}"
}

resource "azurerm_virtual_network" "windows" {
  name                = "${var.win_prefix}-VirtualNetwork"
  address_space       = ["10.0.0.0/16"]
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
}

resource "azurerm_subnet" "windows" {
  name                 = "${var.win_prefix}-Subnet"
  resource_group_name  = "${azurerm_resource_group.main.name}"
  virtual_network_name = "${azurerm_virtual_network.windows.name}"
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_public_ip" "windows" {
  name                = "${var.win_prefix}-PublicIP"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
  allocation_method   = "Dynamic"
}

resource "azurerm_network_security_group" "windows" {
  name                = "${var.win_prefix}-NetworkSecurityGroup"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
}

resource "azurerm_network_interface" "windows" {
  name                      = "${var.win_prefix}-NetworkInterface"
  location                  = "${var.location}"
  resource_group_name       = "${azurerm_resource_group.main.name}"
  network_security_group_id = "${azurerm_network_security_group.windows.id}"

  ip_configuration {
    name                          = "${var.win_prefix}-IPConfiguration"
    subnet_id                     = "${azurerm_subnet.windows.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.windows.id}"
  }

  depends_on = [azurerm_subnet.windows]
}

# Generate random text for a unique storage account name
resource "random_id" "randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = "${azurerm_resource_group.main.name}"
  }

  byte_length = 8
}

# Create storage account for boot diagnostics and install script
resource "azurerm_storage_account" "main" {
  name                     = "diag${random_id.randomId.hex}"
  resource_group_name      = "${azurerm_resource_group.main.name}"
  location                 = "${var.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_virtual_machine" "windows" {
  name                             = "${var.win_prefix}-VM"
  location                         = "${var.location}"
  resource_group_name              = "${azurerm_resource_group.main.name}"
  network_interface_ids            = ["${azurerm_network_interface.windows.id}"]
  vm_size                          = "${var.size}"
  delete_os_disk_on_termination    = "true"
  delete_data_disks_on_termination = "true"

  storage_os_disk {
    name              = "${var.win_prefix}-Storage-OS-Disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  os_profile {
    computer_name  = "WINDOWS"
    admin_username = "${var.admin_username}"
    admin_password = "${var.admin_password}"
  }

  os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = true
  }

  boot_diagnostics {
    enabled     = "true"
    storage_uri = "${azurerm_storage_account.main.primary_blob_endpoint}"
  }
}

resource "azurerm_storage_container" "scripts" {
  name                  = lower("${var.prefix}-Scripts")
  resource_group_name   = "${azurerm_resource_group.main.name}"
  storage_account_name  = "${azurerm_storage_account.main.name}"
  container_access_type = "blob"
}

locals {
  install_windows_agent_path = "${path.module}/scripts/install_azure_pipelines_windows_agent.ps1"
}

resource "azurerm_storage_blob" "install_windows_agent_script" {
  name                   = basename(local.install_windows_agent_path)
  resource_group_name    = "${azurerm_resource_group.main.name}"
  storage_account_name   = "${azurerm_storage_account.main.name}"
  storage_container_name = "${azurerm_storage_container.scripts.name}"
  type                   = "block"
  source                 = local.install_windows_agent_path
}

# Custom Script extension to install the Azure Pipelines agent
# https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/custom-script-windows
resource "azurerm_virtual_machine_extension" "install_windows_agent" {
  name                 = "${var.win_prefix}-CustomScript"
  location             = "${var.location}"
  resource_group_name  = "${azurerm_resource_group.main.name}"
  virtual_machine_name = "${azurerm_virtual_machine.windows.name}"
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

  settings = <<SETTINGS
  {
  "fileUris": ["${azurerm_storage_blob.install_windows_agent_script.url}"],
  "commandToExecute": "powershell.exe -ExecutionPolicy Unrestricted -File ./${azurerm_storage_blob.install_windows_agent_script.name} -URL ${var.azure_devops_url} -TOKEN ${var.token} -POOL ${var.pool} -AGENT ${var.agent}"
  }
SETTINGS
}
