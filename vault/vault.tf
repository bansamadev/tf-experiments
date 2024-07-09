data "docker_registry_image" "vault_image" {
  name = "hashicorp/vault:1.17"
}

variable "vault_token" {
  type      = string
  sensitive = true
}

variable "jenkins_password" {
  type      = string
  sensitive = true
}

resource "docker_image" "vault_image" {
  name          = data.docker_registry_image.vault_image.name
  pull_triggers = [data.docker_registry_image.vault_image.sha256_digest]
  keep_locally  = true
}

resource "docker_container" "vault" {
  image   = docker_image.vault_image.image_id
  name    = "vault"
  restart = "on-failure"

  env = [
    "VAULT_DEV_ROOT_TOKEN_ID=${var.vault_token}",
  ]


  capabilities {
    add = ["IPC_LOCK"]
  }

  ports {
    internal = 8200
    external = 8200
  }

}

resource "vault_auth_backend" "userpass" {
  type = "userpass"
}

resource "vault_policy" "admin" {
  name   = "admin"
  policy = <<EOT
path "*" {
  capabilities = ["sudo", "create", "read", "update", "patch", "delete", "list"]
}
EOT
}

resource "vault_generic_endpoint" "admin" {
  depends_on           = [vault_auth_backend.userpass]
  path                 = "auth/userpass/users/admin"
  ignore_absent_fields = true
  data_json            = <<EOT
{
  "policies": ["admin"],
  "password": "${var.vault_token}"
}
EOT
}

resource "vault_generic_endpoint" "jenkins" {
  depends_on           = [vault_auth_backend.userpass]
  path                 = "auth/userpass/users/jenkins "
  ignore_absent_fields = true
  data_json            = <<EOT
{
  "policies": ["default"],
  "password": "${var.jenkins_password}"
}
EOT
}
