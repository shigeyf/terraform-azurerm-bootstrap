// _variables.tf

variable "location" {
  description = "Azure region for the deployment"
  type        = string
}

variable "tags" {
  description = "Tags for the deployed resources"
  type        = map(string)
  default     = {}
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "storage_account_name" {
  description = "Name of the storage account"
  type        = string
}

variable "tfstate_container_name" {
  description = "Name of the storage container storing Terraform state files"
  type        = string
  default     = "tfstate"
}

variable "enable_user_assigned_identity" {
  description = "Enable User-assigned Identity for the storage account"
  type        = bool
  default     = false
}

variable "storage_uami_name" {
  description = "Name of the User-assigned Identity for the storage account"
  type        = string
  default     = ""

  validation {
    condition     = var.enable_user_assigned_identity ? length(var.storage_uami_name) > 0 : true
    error_message = "'storage_uami_name' must be set if 'enable_user_assigned_identity' is true."
  }
}

variable "keyvault_name" {
  description = "Name of the Key Vault"
  type        = string
}

variable "enable_storage_customer_managed_key" {
  description = "Enable Customer Managed Key for the storage account"
  type        = bool
  default     = false
}

variable "storage_customer_managed_key_policy" {
  description = "Key policy for the Storage CMK"
  type = object({
    key_type        = string
    key_size        = optional(number, 4096)
    curve_type      = optional(string)
    expiration_date = optional(string, null)
    rotation_policy = optional(object({
      automatic = optional(object({
        time_after_creation = optional(string)
        time_before_expiry  = optional(string, "P30D")
      }))
      expire_after         = optional(string, "P30D")
      notify_before_expiry = optional(string, "P29D")
    }))
  })
  default = {
    key_type = "RSA"
    key_size = 4096
    rotation_policy = {
      automatic = {
        time_before_expiry = "P30D"
      }
      expire_after         = "P90D"
      notify_before_expiry = "P29D"
    }
  }
}

variable "bootstrap_config_filename" {
  description = "Path to the bootstrap output file"
  type        = string
  default     = "./bootstrap.config.json"
}

variable "tfbackend_config_template_filename" {
  description = "Path to the backend config template file"
  type        = string
  default     = "./azurerm.tfbackend"
}
