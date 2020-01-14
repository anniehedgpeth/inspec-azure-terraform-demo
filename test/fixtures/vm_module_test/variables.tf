variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}
variable "resource_group" {
  default = "test-kitchen"
}
variable "admin_username" {
  default = "tkuser"
}
variable "computer_name" {
  default = "tkcomputer"
}
