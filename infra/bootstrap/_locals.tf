// _locals.tf

locals {
  resource_group_name = azurerm_resource_group.base.name
  storage_id          = module.tfbackend.output.storage_id
  storage_name        = element(reverse(split("/", module.tfbackend.output.storage_id)), 0)
  keyvault_id         = module.kv.output.keyvault_id
  keyvault_name       = element(reverse(split("/", module.kv.output.keyvault_id)), 0)
}
