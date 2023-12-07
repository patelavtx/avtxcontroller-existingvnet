# For azure Controller Image Update deployment via Terraform Cloud

## Ref

+  Modules referenced - 
**https://github.com/AviatrixSystems/terraform-aviatrix-azure-controller**

**https://github.com/AviatrixSystems/terraform-modules-copilot**



+  Documentation 
**https://read.docs.aviatrix.com/StartUpGuides/azure-aviatrix-cloud-controller-startup-guide.html**




## STEPS for controller image upgrade into existing vnet


- ![#c5f015](https://placehold.co/15x15/c5f015/c5f015.png) `1. Deploy new controller  (use_new_eip = true (default))`

- ![#c5f015](https://placehold.co/15x15/c5f015/c5f015.png) `2. Follow the steps to dis-associate/associate EIP and restore from backup (see DOC)`

   **IMPORTANT to restore using original controller EIP associated as otherwise the Gateway communications may be disrupted as SG rules will not be present**


- ![#c5f015](https://placehold.co/15x15/c5f015/c5f015.png) `3. If environment is stable, (use_new_eip = false)  -   re-apply,  this associates the 'original controller EIP' to the 'new controller' TF code`

- ![#c5f015](https://placehold.co/15x15/c5f015/c5f015.png) `4. Terraform import state -  uncomment lines 169-203 in root module main.tf ;  run through import commands`





## Configuration steps for the Azure controller vm deployment

THIS can deploy both controller/copilot.
The 'init' module can be enabled/disabled by setting variable 'enableinit' (disabled by default), though 
this requires specific python environment and modules, check the module link above.


Check the 'variables.tf' for the variables that require setting.

**EG**  - Example of *tfvars file 


```

# Needed for build module
use_existing_vnet = true
vnet_name           = var.vnet_name
subnet_id           = var.subnet_id
subnet_name         = var.subnet_name  
resource_group_name = var.resource_group_name


# for STEP2 - AFTER restore and import, toggle 'use_new_eip' by uncommenting the below
#use_new_eip = "false"                  # first run leave uncommented default is true; use after association of original ctl eip
eip_name = "orig-ctl-public-ip"      #  Will only be used when 'use_new_eip' is toggled to false; change value to original ctl eip name

# Additional variables needed for running init module
enableinit          = false                      # if the Terraform deployment environment meets python requirements can run the INIT module

directory_id        = var.directory_id 
subscription_id     = var.subscription_id
application_id      = var.application_id
application_key     = var.application_key
account_email       = var.account_email
app_name            = var.app_name
access_account_name = var.access_account_name
controller_version  = var.controller_version
aviatrix_customer_id= var.aviatrix_customer_id

```









### For copilot deployment set variable:

```
enablecop = "true"   (by default it is false)

```



Deploy:

A push of the repo or manually via the Terraform Cloud workspace associated with the repo:

```
terraform plan
terraform apply

```


