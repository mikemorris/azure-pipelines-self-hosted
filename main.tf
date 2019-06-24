module "azure_pipelines_agent" {
  source           = "./azure_pipelines_agent"
  azure_devops_url = var.azure_devops_url
  token            = var.token
  admin_username   = var.admin_username
  admin_password   = var.admin_password
}
