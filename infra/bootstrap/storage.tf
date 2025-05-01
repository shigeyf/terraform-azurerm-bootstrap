// storage.tf

module "tfbackend" {
  # tflint-ignore: terraform_module_pinned_source
  source = "git::https://github.com/shigeyf/terraform-azurerm-reusables.git//infra/terraform/modules/storage?ref=main"

  resource_group_name = local.resource_group_name
  location            = var.location
  tags                = var.tags

  storage_account_name          = var.storage_account_name
  enable_user_assigned_identity = var.enable_user_assigned_identity
  storage_uami_name             = var.storage_uami_name
  enable_public_network_access  = true
  enable_customer_managed_key   = var.enable_storage_customer_managed_key
  customer_managed_key_name     = var.enable_storage_customer_managed_key ? module.tfbackend_cmk[0].output.key_name : null
  keyvault_id                   = module.kv.output.keyvault_id

  containers = [
    {
      name                  = var.tfstate_container_name
      container_access_type = "private"
    }
  ]

  role_assignments = [
    {
      principal_id         = data.azurerm_client_config.current.object_id
      role_definition_name = "Storage Blob Data Owner"
    }
  ]

  depends_on = [
    azurerm_resource_group.base,
    module.tfbackend_cmk,
  ]
}
