// storage.cmk.tf

locals {
  _storage_cmk_name = "cmk-${var.storage_account_name}"
}

module "tfbackend_cmk" {
  count = var.enable_storage_customer_managed_key ? 1 : 0

  # tflint-ignore: terraform_module_pinned_source
  source = "git::https://github.com/shigeyf/terraform-azurerm-reusables.git//infra/terraform/modules/keyvault_key?ref=main"

  key_name    = local._storage_cmk_name
  keyvault_id = module.kv.output.keyvault_id
  key_policy  = var.storage_customer_managed_key_policy

  depends_on = [
    null_resource.wait_for_propagation,
  ]
}
