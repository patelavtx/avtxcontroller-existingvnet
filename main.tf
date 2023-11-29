terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.8.0"
    }
    null = {
      source = "hashicorp/null"
    }
  }
}


/* ***SUMMARY ***
1. Run build module ;  use_new_eip = true (default)
2. Post original controller eip association to new controller toggle use_new_eip = false
3. Comment out eip_name and ensure the name of the original controller eip is updated in *tfvars
4. Run Plan and Apply to bring original controller EIP state information into new controller EIP state.
5. Import  RG-VNET-subnet to new controller state, once done, the original controller state and code can be removed (NOTE do NOT destroy)
(applying destroy will fail as new controller resources will be seen using it, however, best to 'removed' the code and state file)
*/


# Use if making use of outputs to deploy into existing vnet

data "terraform_remote_state" "orig-ctl" {
  backend = "local"
  config = {
    path = "../orig-azctl/terraform.tfstate"
  }
}



# Test2 - use local module
module "aviatrix_controller_build" {
  #source  = "AviatrixSystems/azure-controller/aviatrix//modules/aviatrix_controller_build"
  #version = "2.1.0"
  source = "./aviatrix_controller_build-local"                
  // please do not use special characters such as `\/"[]:|<>+=;,?*@&~!#$%^()_{}'` in the controller_name
  controller_name                           = var.controller_name
  location                                  = var.location
  # line22 and 23 if using new vnet
  controller_vnet_cidr                      = var.controller_vnet_cidr
  controller_subnet_cidr                    = var.controller_subnet_cidr
  controller_virtual_machine_admin_username = var.controller_virtual_machine_admin_username
  controller_virtual_machine_admin_password = var.controller_virtual_machine_admin_password
  controller_virtual_machine_size           = var.controller_virtual_machine_size
  incoming_ssl_cidr                         = var.incoming_ssl_cidr
  


  # ***select either deploying via variables or remote state  (a) or (b) comment out either (a) or (b) ***
  
  # (a) deploy to existing vnet using variables
  #subnet_id = var.subnet_id
  #subnet_name = var.subnet_name
  #use_existing_vnet = var.use_existing_vnet             # set to true to deploy to existing vnet and add RG-vnet-subnet details
  #vnet_name = var.vnet_name
  #resource_group_name = var.resource_group_name


  # (b) deploy to existing vnet - use outputs (remote state)
  subnet_id = data.terraform_remote_state.orig-ctl.outputs.controller_subnetid
  subnet_name = data.terraform_remote_state.orig-ctl.outputs.controller_subnetname
  use_existing_vnet = var.use_existing_vnet
  vnet_name = data.terraform_remote_state.orig-ctl.outputs.controller_vnet.name
  resource_group_name = data.terraform_remote_state.orig-ctl.outputs.controller_vnet.resource_group_name
  


  # *** AFTER manually migrating the orig IP via Azure Portal set 'use_new_eip = false' , uncomment 'eip_name'and run apply to set STATE***

  # (c) eip setting; setting toggle to false to use original controller ip" ;
  # use_new_eip = var.use_new_eip
  # use below to pass to data block when 'use_new_eip = false'
  use_new_eip = var.use_new_eip
  eip_name = var.eip_name
}



#  setting following variable;  enableinit = true wil run this module

module "aviatrix_controller_initialize" {
  source  = "AviatrixSystems/azure-controller/aviatrix//modules/aviatrix_controller_initialize"
  version = "2.1.0"
  #source                        = "./modules/aviatrix_controller_initialize"
  count              = var.enableinit ? 1 : 0
  avx_controller_public_ip      = module.aviatrix_controller_build.aviatrix_controller_public_ip_address
  avx_controller_private_ip     = module.aviatrix_controller_build.aviatrix_controller_private_ip_address
  avx_controller_admin_email    = var.avx_controller_admin_email
  avx_controller_admin_password = var.avx_controller_admin_password
  #arm_subscription_id           = module.aviatrix_controller_azure.subscription_id
  #arm_application_id            = module.aviatrix_controller_azure.application_id
  #arm_application_key           = module.aviatrix_controller_azure.application_key
  #directory_id                  = module.aviatrix_controller_azure.directory_id
  arm_subscription_id           = var.subscription_id 
  arm_application_id            = var.application_id
  arm_application_key           = var.application_key
  directory_id                  = var.directory_id 
  account_email                 = var.account_email
  access_account_name           = var.access_account_name
  aviatrix_customer_id          = var.aviatrix_customer_id
  controller_version            = var.controller_version

  depends_on = [
    module.aviatrix_controller_build
  ]

}


# Modify instance size and disk size under the module ; enablecop=true will run this module
module "copilot_build_azure" {
  source                         = "github.com/AviatrixSystems/terraform-modules-copilot.git//copilot_build_azure"
  count 			 = var.enablecop ? 1 : 0  
  copilot_name                   = var.copilot_name
  add_ssh_key			 = var.add_ssh_key
  virtual_machine_admin_username = var.virtual_machine_admin_username
  virtual_machine_admin_password = var.virtual_machine_admin_password
  location                       = var.location
  use_existing_vnet              = var.use_existing_vnet
  virtual_machine_size           = var.virtual_machine_size            # default
  resource_group_name            = module.aviatrix_controller_build.aviatrix_controller_rg.name
  subnet_id                      = module.aviatrix_controller_build.aviatrix_controller_subnet.id
  default_data_disk_size         = var.default_data_disk_size
  controller_public_ip           = module.aviatrix_controller_build.aviatrix_controller_public_ip_address
  controller_private_ip          = module.aviatrix_controller_build.aviatrix_controller_private_ip_address
  allowed_cidrs = {
    "tcp_cidrs" = {
      priority = "100"
      protocol = "Tcp"
      ports    = ["443"]
      cidrs    = ["0.0.0.0/0"]
    }
    "udp_cidrs" = {
      priority = "200"
      protocol = "Udp"
      ports    = ["5000", "31283"]
      cidrs    = ["0.0.0.0/0"]
    }

  }

  #additional_disks = {
  #  "one" = {
  #    managed_disk_id = azurerm_managed_disk.source.id
  #    lun             = "1"
  #  }
    #  "two" = {
    #   managed_disk_id = "<< managed disk id 2 >>"
    #  lun = "2"
    #  }
  #}
  depends_on = [
    module.aviatrix_controller_build
  ]
}


# add here the rg-vnet-subnet blocks



# 1. Create an Azure resource group
resource "azurerm_resource_group" "aviatrix_controller_rg" {
  location = var.location
  #name     = "${var.controller_name}-rg"
  name = "orig-ctl-rg"
}


# 2. Create the Virtual Network and Subnet
//  Create the Virtual Network
resource "azurerm_virtual_network" "aviatrix_controller_vnet" {
  address_space       = [var.controller_vnet_cidr]
  location            = var.location
  name                = "orig-ctl-vnet"
  resource_group_name = azurerm_resource_group.aviatrix_controller_rg.name
}


//  Create the Subnet
resource "azurerm_subnet" "aviatrix_controller_subnet" {
  name                 = "orig-ctl-subnet"
  resource_group_name  = azurerm_resource_group.aviatrix_controller_rg.name
  virtual_network_name = azurerm_virtual_network.aviatrix_controller_vnet.name
  address_prefixes     = [var.controller_subnet_cidr]
}



