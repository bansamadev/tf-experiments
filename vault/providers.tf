terraform {
  required_providers {
    docker = {
      # https://github.com/kreuzwerker/terraform-provider-docker/pull/583
      source  = "bamhm182/docker"
      version = "~> 0.0.3"
    }
  }
}
