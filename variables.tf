
variable "controller_name" {
  type        = string
  description = "Customized Name for Aviatrix Controller"
  default = "AzController1-migto"
}

variable "controller_subnet_cidr" {
  type        = string
  description = "CIDR for controller subnet."
  default     = "10.66.0.0/26"
}

variable "controller_virtual_machine_admin_username" {
  type        = string
  description = "Admin Username for the controller virtual machine."
  default     = "aviatrix"
}

variable "controller_virtual_machine_admin_password" {
  type        = string
  description = "Admin Password for the controller virtual machine."
  default     = "Aviatrix123#"
}

variable "controller_virtual_machine_size" {
  type        = string
  description = "Virtual Machine size for the controller."
  default     = "Standard_A4_v2"
}

variable "controller_vnet_cidr" {
  type        = string
  description = "CIDR for controller VNET."
  default     = ""
}


variable "use_existing_vnet" {
  type        = string
  description = ""
  default     = "true"
}

variable "vnet_name" {
  type        = string
  description = ""
  default     = ""
}

variable "subnet_id" {
  type        = string
  description = ""
  default     = ""

variable "subnet_name" {
  type        = string
  description = ""
  default     = ""
}


variable "resource_group_name" {
  type        = string
  description = ""
  default     = ""
}

variable "incoming_ssl_cidr" {
  type        = list(string)
  description = "Incoming cidr for security group used by controller"
  default = ["0.0.0.0/0"]
}

variable "location" {
  type        = string
  description = "Resource Group Location for Aviatrix Controller"
  default     = "UK South"
}

variable "avx_controller_admin_email" {
  type        = string
  description = "aviatrix controller admin email address"
  default = ""
}

variable "avx_controller_admin_password" {
  type        = string
  description = "aviatrix controller admin password"
  default = "Aviatrix123#"
}

variable "directory_id" {
  type        = string
  default = ""
}

variable "subscription_id" {
  type        = string
  default = ""
}

variable "application_id" {
  type        = string
  default = ""
}

variable "application_key" {
  type        = string
  default = ""
}

variable "account_email" {
  type        = string
  description = "aviatrix controller access account email"
  default = ""
}

variable "app_name" {
  type        = string
  description = "Azure AD App Name for Aviatrix Controller Build Up"
  default     = ""
}

variable "access_account_name" {
  type        = string
  description = "aviatrix controller access account name"
  default = ""
}

variable "controller_version" {
  type        = string
  description = "Aviatrix Controller version"
  default     = ""
}

variable "aviatrix_customer_id" {
  type        = string
  description =  "needed if running init module"
  default = ""
}


# Copilot
variable "copilot_name" {
  type = string
  default = "Azcopilot1"
}


variable "add_ssh_key" {
  type = string
  default = "false"
}

variable "virtual_machine_size" {
  type        = string
  description = ""
  default     = "Standard_A4_v2"
}

variable "virtual_machine_admin_username" {
  type        = string
  description = ""
  default     = "aviatrix"
}

variable "virtual_machine_admin_password" {
  type        = string
  description = ""
  default     = "Aviatrix123#"
}

variable "default_data_disk_size" {
  type = string
  default = "30"
}


# option to init or copilot
variable "enableinit" {
  type        = string
  default = "false"
}

variable "enablecop" {
  type        = string
  default = "false"
}
