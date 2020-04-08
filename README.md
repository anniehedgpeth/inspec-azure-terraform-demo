# inspec-azure-terraform-demo

Documentation:
https://github.com/inspec/inspec-azure
https://github.com/newcontext-oss/kitchen-terraform

Slides:
https://www.slideshare.net/AnnieHedgpeth/terraform-testing-with-inspec-demo

Blog post on which talk was based:
http://www.anniehedgie.com/kitchen-terraform-and-inspec

## Prerequisites

 - InSpec is [installed](https://www.inspec.io/downloads/) (skip this if using Bundler to install gem dependencies)
 - an Azure service principal with contributor rights
 - Terraform [installed](https://www.terraform.io/downloads.html)
 - `kitchen-terraform` gem is installed (skip this if using Bundler to install gem dependencies)
 - `bundler` gem is installed
 - `az cli` is installed

## Why would I need this:
In order to validate Azure resources, we can use the inspec-azure gem to run automated tests against Azure. When we're automating provisioning through Terraform, we can add this InSpec validation onto the end of our Terraform run.

## What this demo does:

1. InSpec is running locally against your Azure subscription and against the node being provisioned through Test Kitchen.
2. It is validating that your subscription and VM are in the states in which they are expected to be in as defined by the InSpec.

## What to do:

With Test Kitchen, we're just going to create a few resources inside a resource group in Azure on  your subscription, and then we'll validate that what we wanted to be created actually got created. (The tests in this InSpec profile are expected to pass.)

1. Change the values in either the `.envrc.sh` for Mac or Linux or `.envrc.ps1` for Windows using your Azure service principal values and run it.

2. Clone this repository on your workstation.

```
git clone https://github.com/anniehedgpeth/inspec-azure-terraform-demo.git
```

4. From the command line of your choice, run these commands from this repository's directory.

```
$ bundle install
$ bundle exec kitchen create
```

When you run this command, it runs `terraform init` and `terraform workspace select` under the hood. The path for the module for which you're running Terraform is directed to separated wrapper module nested in `test/fixtures`.

```
$ bundle exec kitchen converge
```

When you run this command, it runs `terraform plan` and `terraform apply` under the hood.

```
$ bundle exec kitchen verify
```

When you run this command, it runs `inspec exec` against the Azure subscription and IP address under the hood.

Your output will likely look like the following:

```
vm: Verifying host 168.61.162.15
Skipping profile: 'inspec-azure' on unsupported platform: 'ubuntu/16.04'.

Profile: Demo VM Profile (demo-vm-test)
Version: 0.1.0
Target:  ssh://tkuser@168.61.162.15:22

  ✔  vm config: User tkuser
     ✔  User tkuser home is expected to eq "/home/tkuser"
     ✔  Directory /home/tkuser is expected to exist
     ✔  Directory /home/tkuser owner is expected to eq "tkuser"


Profile Summary: 1 successful control, 0 control failures, 0 controls skipped
Test Summary: 3 successful, 0 failures, 0 skipped
azure: Verifying

Profile: Demo VM Profile (demo-vm-test)
Version: 0.1.0
Target:  azure://09f2ee05-2cb0-4996-a24e-b4d3083b0cbd

  ✔  resources: 'my_vm' Virtual Machine
     ✔  'my_vm' Virtual Machine is expected to exist
     ✔  'my_vm' Virtual Machine type is expected to eq "Microsoft.Compute/virtualMachines"
     ✔  'nsg' Network Security Group is expected to exist
     ✔  'nsg' Network Security Group is expected to allow ssh from internet
     ✔  'nsg' Network Security Group type is expected to eq "Microsoft.Network/networkSecurityGroups"
     ✔  'nsg' Network Security Group security_rules is expected not to be empty
     ✔  'nsg' Network Security Group default_security_rules is expected not to be empty
     ✔  'my_network' Virtual Network is expected to exist
     ✔  'my_network' Virtual Network location is expected to eq "centralus"


Profile: Azure Resource Pack (inspec-azure)
Version: 1.10.0
Target:  azure://09f2ee05-2cb0-4996-a24e-b4d3083b0cbd

     No tests executed.

Profile Summary: 1 successful control, 0 control failures, 0 controls skipped
Test Summary: 9 successful, 0 failures, 0 skipped
       Finished verifying <vm-module-test-terraform> (0m5.71s).
-----> Kitchen is finished. (0m7.32s)
```

5. After you are finished, don't forget to destroy the resources you just created with:

```
$ bundle exec kitchen destroy
```

This runs `terraform destroy` under the hood, and only destroys the resources in your .tfstate file created for your Test Kitchen module.