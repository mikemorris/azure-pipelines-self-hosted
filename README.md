Based heavily on https://melcher.dev/2019/03/self-hosted-azure-devops-build/release-agent-with-terraform-windows-edition/

## Deploy infrastructure with Terraform

- [Create an Azure account](https://azure.microsoft.com/en-us/free/) and an [Azure DevOps Organization](https://dev.azure.com/).
- `brew install az terraform`
- `az login`
- `terraform init`
- [Register for VirtualMachineImages preview feature](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/image-builder#register-the-features), wait several minutes for feature registration to complete, then register for the `VirtualMachineImages` and `Storage` providers.
- Create a Personal Access Token (PAT) with _only_ the **Agent Pools (Read & manage)** scope and save it somewhere secure. You will need to pass this value to Terraform in the `token` variable at run time.
- Run `terraform apply` to create a VM (with all required resources) and install the Azure Pipelines agent.
- View registered agents at https://dev.azure.com/{ORGANIZATION}/_settings/agentpools, you should see a new `Self-Hosted` agent appear in the Default pool.
- Create an Azure DevOps project in your organization, import or create an Azure Pipelines YAML configuration specifying an [Agent pool job](https://docs.microsoft.com/en-us/azure/devops/pipelines/process/phases?view=azure-devops&tabs=yaml#agent-pool-jobs), then navigate to Project Settings > Pipelines > Agent Pools, select the Default pool, then, under the Security tab, grant access permission to all pipelines.

## Create a CI infrastructure deployment (not yet implemented)

- Configure an Azure Service Principal with permission to deploy infrastructure changes.
  - Uses the [Azure Active Directory](https://www.terraform.io/docs/providers/azuread/index.html) Terraform provider to create an Active Directory Application, Service Principal and the [Azure](https://www.terraform.io/docs/providers/azurerm/index.html) Terraform provider to create a Role Assignment.
  - Run `az ad sp show --id $(terraform output serivce-principal-id)` to show the Service Principal.
  - Run `source ./service-principal/configure_service_principal.sh` to [configure Terraform environment variables](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/terraform-install-configure#configure-terraform-environment-variables) to use the Serivce Principal you just created.
  - Create a new client secret in [Azure Active Directory](https://portal.azure.com/#blade/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade/Overview) under App registrations -> YOUR_APP -> Certificates & Secrets then set it in your shell with `export ARM_CLIENT_SECRET=`, pasting your new secret after the equals sign.
  - [Run a sample script](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/terraform-install-configure#run-a-sample-script) (or just `terraform plan`) to confirm that the Serivce Principal has been configured properly.

## Additional resources

- https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/v2-windows?view=azure-devops#unattended-config
- https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/custom-script-windows#troubleshoot-and-support
  - Because SAC is limited to an 80x24 screen buffer with no scroll back, add `| more` to commands to display the output one page at a time. Use <spacebar> to see the next page, or <enter> to see the next line.

These tutorials follow the approach of building a virtual machine VHD image with [Packer](http://packer.io/), which may be worth looking into [if Terraform adds support for the Azure Image Builder service](https://github.com/terraform-providers/terraform-provider-azurerm/issues/3591).

- https://www.mikaelkrief.com/private-azure-devops-agent/
- https://docs.microsoft.com/en-us/azure/terraform/terraform-create-vm-scaleset-network-disks-using-packer-hcl
- https://docs.microsoft.com/en-us/azure/virtual-machines/windows/image-builder
