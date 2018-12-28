variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

resource "azurerm_resource_group" "my-rg" {
  name     = "my-resources"
  location = "Central US"
}

resource "azurerm_virtual_network" "my-vnet" {
  name                = "my-network"
  address_space       = ["10.0.0.0/16"]
  location            = "${azurerm_resource_group.my-rg.location}"
  resource_group_name = "${azurerm_resource_group.my-rg.name}"
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = "${azurerm_resource_group.my-rg.name}"
  virtual_network_name = "${azurerm_virtual_network.my-vnet.name}"
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_network_interface" "my-vnet" {
  name                = "my-nic"
  location            = "${azurerm_resource_group.my-rg.location}"
  resource_group_name = "${azurerm_resource_group.my-rg.name}"

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = "${azurerm_subnet.internal.id}"
    private_ip_address_allocation = "dynamic"
  }
}

resource "azurerm_virtual_machine" "my-vm" {
  name                  = "my-vm"
  location              = "Central US"
  resource_group_name   = "${azurerm_resource_group.my-rg.name}"
  network_interface_ids = ["${azurerm_network_interface.my-vnet.id}"]
  vm_size               = "Standard_F2"

  # This means the OS Disk will be deleted when Terraform destroys the Virtual Machine
  # NOTE: This may not be optimal in all cases.
  delete_os_disk_on_termination = true

  # This means the Data Disk Disk will be deleted when Terraform destroys the Virtual Machine
  # NOTE: This may not be optimal in all cases.
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

resource "azurerm_network_security_group" "nsg" {
  name                = "nsg"
  location            = "${azurerm_resource_group.my-rg.location}"
  resource_group_name = "${azurerm_resource_group.my-rg.name}"
}

resource "azurerm_network_security_rule" "8080" {
  name                        = "8080"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.my-rg.name}"
  network_security_group_name = "${azurerm_network_security_group.nsg.name}"
}

resource "null_resource" "inspec" {
    provisioner "local-exec" {
        command = "inspec exec https://github.com/anniehedgpeth/inspec-azure-demo.git -t azure://${var.subscription_id}"
    }
}