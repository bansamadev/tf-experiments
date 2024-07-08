module "jenkins_server" {
  source        = "./jenkins"
  jenkins_nodes = module.jenkins_nodes.ip_adapters
  depends_on = [
    module.jenkins_nodes
  ]

}

module "jenkins_nodes" {
  source         = "./jenkins_nodes"
  jenkins_nodes  = 2
  host_interface = var.host_interface
}

module "vault" {
  source      = "./vault"
  vault_token = var.vault_token
}
