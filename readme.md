# Installing multiple VM extensions on an Azure VM using Terraform
In a recent project, we were using Azure Datafactory in a closed network and we needed to access resources on-premises. That means that you cannot use the Autoresolve runtime of datafactory. We thus used our own VM and installed the Self Hosted Integration Runtime software using a VM extension. So far, so good. A little later in the project we needed to install another piece of software on that VM. I started adding another VM extension only to find out that you can only install one VM extension per VM on Azure. We needed to find a way to install multiple depencies on the VM using a single VM extension in a configurable and manageble way. This code is an example of that. More can be found in [this](http://erwinstaal.nl/posts/azure-vm-multiple-vm-extensions-using-terraform/) blog post.