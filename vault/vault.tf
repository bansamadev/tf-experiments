data "docker_registry_image" "vault_image" {
  name = "hashicorp/vault:1.17"
}

variable "vault_token" {
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

  env = ["VAULT_DEV_ROOT_TOKEN_ID=${var.vault_token}",
    "VAULT_LOCAL_CONFIG={\"storage\": {\"file\": {\"path\": \"/vault/file\"}}, \"listener\": [{\"tcp\": { \"address\": \"0.0.0.0:8200\", \"tls_disable\": true}}], \"default_lease_ttl\": \"168h\", \"max_lease_ttl\": \"720h\", \"ui\": true}"
  ]

  capabilities {
    add = ["IPC_LOCK"]
  }


  ports {
    internal = 8200
    external = 8200
  }
  ports {
    internal = 50000
    external = 50000
  }


}
