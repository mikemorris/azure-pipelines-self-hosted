#!/bin/sh
echo "Setting environment variables for Terraform"

export ARM_SUBSCRIPTION_ID="$(terraform output subscription-id | sed 's/\/subscriptions\///')"
echo ARM_SUBSCRIPTION_ID=$ARM_SUBSCRIPTION_ID

export ARM_CLIENT_ID=$(az ad sp show --id `terraform output serivce-principal-id` --query appId  | sed 's/"//g')
echo ARM_CLIENT_ID=$ARM_CLIENT_ID

# export ARM_CLIENT_SECRET=your_password
# echo ARM_CLIENT_SECRET=$ARM_CLIENT_SECRET

export ARM_TENANT_ID=$(az ad sp show --id `terraform output serivce-principal-id` --query appOwnerTenantId | sed 's/"//g')
echo ARM_TENANT_ID=$ARM_TENANT_ID

# Not needed for public, required for usgovernment, german, china
export ARM_ENVIRONMENT=public
