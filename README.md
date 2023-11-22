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
# Needed for running init module
#subnet_id = var.subnet_id
#subnet_name = var.subnet_name
enableinit = false                      # if the Terraform deployment environment meets python requirements can run the INIT module
#vnet_name = var.vnet_name
#resource_group_name = var.resource_group_name


# Needed for build module
use_existing_vnet = true
vnet_name = 
subnet_id = 
subnet_name =  
resource_group_name =

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



## Configuration of variables required if running the 'init' module

```
variable "directory_id" 

variable "subscription_id" 
 
variable "application_id" 
 
variable "application_key" 

variable "account_email" 
 
variable "app_name" 
  
variable "access_account_name" 

variable "controller_version" 
  
variable "aviatrix_customer_id" 
 
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