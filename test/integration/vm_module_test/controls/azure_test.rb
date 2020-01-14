control 'resources' do
  resource_group = 'test-kitchen2'

  describe azurerm_virtual_machine(resource_group: resource_group, name: 'my_vm') do
    it                                { should exist }
    its('type')                       { should eq 'Microsoft.Compute/virtualMachines' }
  end

  describe azurerm_network_security_group(resource_group: resource_group, name: 'nsg') do
    it                            { should exist }
    its('type')                   { should eq 'Microsoft.Network/networkSecurityGroups' }
    its('security_rules')         { should_not be_empty }
    its('default_security_rules') { should_not be_empty }
    it                            { should allow_ssh_from_internet }
  end

  describe azurerm_virtual_network(resource_group: resource_group, name: 'my_network') do
    it               { should exist }
    its('location')  { should eq 'centralus' }
  end
end
