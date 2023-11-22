# Azure Controller deployment via Terraform Cloud

## Ref

+  Modules referenced - [*https://github.com/AviatrixSystems/terraform-aviatrix-azure-controller  (Controller)*]
                      - [*https://github.com/AviatrixSystems/terraform-modules-copilot            (Copilot)*]


+  Documentation      = [*https://read.docs.aviatrix.com/StartUpGuides/azure-aviatrix-cloud-controller-startup-guide.html*]


** Prequisites **:    

```
* Customer ID (license required) - Needed at time of Terraform apply if running 'init module' - Note, this module has python requirements

* Service Principal to add to the 'Access Account' in the Controller - requires 'contributor' at the Azure subscription level.
(https://learn.microsoft.com/en-us/azure/active-directory/develop/howto-create-service-principal-portal)

az ad sp create-for-rbac --name myServicePrincipalName \
                         --role contributor \
                         --scopes /subscriptions/mySubscriptionID/resourceGroups/myResourceGroupName


```


## Configuration steps following the Azure controller vm deployment

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





**If 'init' module not run the following needs to be done post deployment**

```
1. Login initially using private ip as password
2. Set email address
3. Change password
4. Set proxy or skip
5. Select software version (6.9.latest is fine)
6. Login and set 'customer_id - license' 
7. Setup 'access account (Azure SP with contributor at Subs level ) - https://read.docs.aviatrix.com/HowTos/Aviatrix_Account_Azure.html
8. Enable copilot connection if copilot deployed         (not required for controller image update)
9. Other (setup syslog / netflow if copilot setup)

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




##  Example of Workspace variables and variable set

![Architecture](https://github.com/patelavtx/LabShare/blob/main/AzCtrl-TFCvars.PNG)


![Architecture](https://github.com/patelavtx/LabShare/blob/main/AzCtrl-TFCvarset.PNG)



##  Example of Resulting Terraform plan

![Architecture](https://github.com/patelavtx/LabShare/blob/main/AzCtrl-TFplan.PNG)