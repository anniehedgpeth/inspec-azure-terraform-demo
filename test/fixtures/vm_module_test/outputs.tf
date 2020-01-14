output "resource_group" {
  value = var.resource_group
}

output "location" {
  value = var.location
}

output "vm_public_ip_address" {
  value = module.inspec-azure-terraform-demo.public_ip_address
}