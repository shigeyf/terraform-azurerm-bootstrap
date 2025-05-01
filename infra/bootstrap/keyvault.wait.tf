// keyvault.wait.tf

resource "null_resource" "wait_for_propagation" {
  triggers = {
    wait = module.kv.ra_propagation_delay
  }
}
