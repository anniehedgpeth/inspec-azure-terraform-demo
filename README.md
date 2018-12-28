# inspec-azure-terraform-demo

Documentation: https://github.com/inspec/inspec-azure

## Prerequisites

 - InSpec is [installed](https://www.inspec.io/downloads/)
 - an Azure service principal with contributor rights
 - a .azure/credentials file in your home directory (see ["SETTING UP THE AZURE CREDENTIALS FILE"](https://www.inspec.io/docs/reference/platforms/))
 - Terraform [installed](https://www.terraform.io/downloads.html)

## Why would I need this:
In order to validate Azure resources, we can use the inspec-azure gem to run automated tests against Azure. When we're automating provisioning through Terraform, we can add this InSpec validation onto the end of our Terraform run.

## What InSpec shows in this demo:

1. InSpec is running locally against your Azure subscription. 

2. It is validating that your subscription is in the state in which it is expected to be in as defined by the InSpec profile directly after Terraform provisions it.

## What to do:

We're just going to create a few resources inside a resource group in Azure on  your subscription, and then we'll validate that what we wanted to be created actually got created. (The tests in this InSpec profile are expected to pass.)

1. Log into Azure via Azure CLI or Azure Powershell using your Azure service principal.

2. Clone this repository on your workstation.

```
git clone https://github.com/anniehedgpeth/inspec-azure-terraform-demo.git
```

3. In this directory, create a `terraform.tfvars` file that has the following in it with your service principal values:

```
subscription_id = "REPLACE-WITH-YOUR-SUBSCIPRTION-ID"
client_id = "REPLACE-WITH-YOUR-CLIENT-ID"
client_secret = "REPLACE-WITH-YOUR-CLIENT-SECRET"
tenant_id = "REPLACE-WITH-YOUR-TENANT-ID"
```

4. From the command line of your choice, run these commands from this repository's directory.

```
$ terraform plan
```

When you run this command, Terraform is comparing what is in the tfstate file, .tf files, and the Azure subscription to see what needs to be created or changed. If this succeeds, then you can run this to provision the resources:

```
$ terraform apply
```

The very last resource in this Terraform script (vm.tf) is a command to run the InSpec profile that exists [here](https://github.com/anniehedgpeth/inspec-azure-demo).

Your output will likely look like the following, mostly failures with a few passing tests:

```
Profile: InSpec Azure Demo (inspec-azure-demo)
Version: 0.1.0
Target:  azure://[hidden]

  ✔  azurerm_virtual_machine: 'my-vm' Virtual Machine
     ✔  'my-vm' Virtual Machine should exist
     ✔  'my-vm' Virtual Machine type should eq "Microsoft.Compute/virtualMachines"
  ✔  azure_network_security_group: 'nsg' Network Security Group
     ✔  'nsg' Network Security Group should exist
     ✔  'nsg' Network Security Group should not allow rdp from internet
     ✔  'nsg' Network Security Group should not allow ssh from internet
     ✔  'nsg' Network Security Group type should eq "Microsoft.Network/networkSecurityGroups"
     ✔  'nsg' Network Security Group security_rules should not be empty
     ✔  'nsg' Network Security Group default_security_rules should not be empty
  ✔  azure_virtual_network: 'my-network' Virtual Network
     ✔  'my-network' Virtual Network should exist
     ✔  'my-network' Virtual Network location should eq "centralus"


Profile: Azure Resource Pack (inspec-azure)
Version: 1.2.0
Target:  azure://[hidden]

     No tests executed.

Profile Summary: 3 successful controls, 0 control failures, 0 controls skipped
Test Summary: 10 successful, 0 failures, 0 skipped
```

5. After you are finished, don't forget to destroy the resources you just created with:

```
$ terraform destroy
```