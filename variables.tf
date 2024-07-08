data "external" "env" {
  program = ["${path.module}/env.sh"]
}

variable "host_interface" {
  type    = string
  default = "wlp0s20f3"
}

variable "vault_token" {
  type      = string
  default   = "vault_token"
  sensitive = true
}

output "jenkins_nodes" {
  value = module.jenkins_nodes.ip_adapters
}
