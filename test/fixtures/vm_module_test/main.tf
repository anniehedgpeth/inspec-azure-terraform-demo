module "inspec-azure-terraform-demo" {
  source = "../../.."

  resource_group  = var.resource_group
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  admin_username  = "tkuser"
  admin_password  = "N0tS3cur3"
  computer_name   = "tkcomputer"
}