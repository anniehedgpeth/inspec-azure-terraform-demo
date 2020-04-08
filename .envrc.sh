# for Terraform
export ARM_SUBSCRIPTION_ID="replace"
export ARM_CLIENT_ID="replace"
export ARM_TENANT_ID="replace"
export ARM_CLIENT_SECRET="replace"

# for InSpec
export AZURE_SUBSCRIPTION_ID="replace"
export AZURE_CLIENT_ID="replace"
export AZURE_TENANT_ID="replace"
export AZURE_CLIENT_SECRET="replace"

az login --service-principal --username $AZURE_CLIENT_ID --password $AZURE_CLIENT_SECRET --tenant $AZURE_TENANT_ID
