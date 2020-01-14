provider "azurerm" {}

resource "azurerm_resource_group" "my_rg" {
  name     = var.resource_group
  location = "Central US"
}

resource "azurerm_virtual_network" "my_vnet" {
  name                = "my_network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.my_rg.location
  resource_group_name = azurerm_resource_group.my_rg.name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.my_rg.name
  virtual_network_name = azurerm_virtual_network.my_vnet.name
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  subnet_id                 = "${azurerm_subnet.internal.id}"
  network_security_group_id = "${azurerm_network_security_group.nsg.id}"
}

resource "azurerm_public_ip" "publicip" {
  name                = "publicip"
  location            = azurerm_resource_group.my_rg.location
  resource_group_name = azurerm_resource_group.my_rg.name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "my_vnet" {
  name                = "my_nic"
  location            = azurerm_resource_group.my_rg.location
  resource_group_name = azurerm_resource_group.my_rg.name

  ip_configuration {
    name                 = "testconfiguration1"
    subnet_id            = azurerm_subnet.internal.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id = azurerm_public_ip.publicip.id
  }
}

resource "azurerm_virtual_machine" "my_vm" {
  name                             = "my_vm"
  location                         = "Central US"
  resource_group_name              = azurerm_resource_group.my_rg.name
  network_interface_ids            = [azurerm_network_interface.my_vnet.id]
  vm_size                          = "Standard_F2"
  delete_os_disk_on_termination    = true
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
    computer_name  = var.computer_name
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

resource "azurerm_network_security_group" "nsg" {
  name                = "nsg"
  location            = azurerm_resource_group.my_rg.location
  resource_group_name = azurerm_resource_group.my_rg.name
}

resource "azurerm_network_security_rule" "ssh" {
  name                        = "inbound-tcp-ssh"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "TCP"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.my_rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

# resource "null_resource" "inspec" {
#   provisioner "local-exec" {
#     command = "chef exec bundle exec inspec exec https://github.com/anniehedgpeth/inspec-azure-demo.git -t azure://${var.subscription_id}"
#   }

#   depends_on = [azurerm_virtual_machine.my_vm]
# }

# Problems:
#  - The resources might not be finished provisioning in time for the tests.
#  - You need separate commands for each InSpec session (i.e. vm or subscription).
#  - If you're developing, then it's cumbersome