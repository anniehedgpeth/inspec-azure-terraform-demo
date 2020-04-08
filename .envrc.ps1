# for Terraform
$ENV:ARM_SUBSCRIPTION_ID="replace"
$ENV:ARM_CLIENT_ID="replace"
$ENV:ARM_TENANT_ID="replace"
$ENV:ARM_CLIENT_SECRET="replace"

# for InSpec
$ENV:AZURE_SUBSCRIPTION_ID="replace"
$ENV:AZURE_CLIENT_ID="replace"
$ENV:AZURE_TENANT_ID="replace"
$ENV:AZURE_CLIENT_SECRET="replace"

az login --service-principal --username $AZURE_CLIENT_ID --password $AZURE_CLIENT_SECRET --tenant $AZURE_TENANT_ID
