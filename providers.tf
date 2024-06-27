terraform {
  required_providers {
    docker = {
      # https://github.com/kreuzwerker/terraform-provider-docker/pull/583
      source  = "bamhm182/docker"
      version = "~> 0.0.3"
    }
    virtualbox = {
      source  = "terra-farm/virtualbox"
      version = "0.2.2-alpha.1"
    }
  }
}

provider "docker" {
  host = data.external.env.result["docker_host"]
}

