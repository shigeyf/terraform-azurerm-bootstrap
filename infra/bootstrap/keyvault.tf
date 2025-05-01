// keyvault.tf

module "kv" {
  # tflint-ignore: terraform_module_pinned_source
  source = "git::https://github.com/shigeyf/terraform-azurerm-reusables.git//infra/terraform/modules/keyvault?ref=main"

  resource_group_name          = local.resource_group_name
  location                     = var.location
  tags                         = var.tags
  keyvault_name                = var.keyvault_name
  enable_public_network_access = true
  purge_protection_enabled     = var.enable_storage_customer_managed_key

  role_assignments = [
    {
      principal_id         = data.azurerm_client_config.current.object_id
      role_definition_name = "Key Vault Administrator"
    },
  ]

  depends_on = [
    azurerm_resource_group.base,
  ]
}
