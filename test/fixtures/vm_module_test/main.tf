module "inspec-azure-terraform-demo" {
  source = "../../.."

  resource_group  = var.resource_group
  admin_username  = "tkuser"
  admin_password  = "N0tS3cur3"
  computer_name   = "tkcomputer"
}