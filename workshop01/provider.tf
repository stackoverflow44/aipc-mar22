terraform {
  required_version = "v1.1.7"
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.16.0"
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.2.2"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.do_token
}

provider "local" {}
