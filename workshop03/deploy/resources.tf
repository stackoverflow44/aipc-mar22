data "digitalocean_ssh_key" "digitalocean" {
  name = "digitalocean"
}

// store local variables
locals {
  web_server_name    = "code-server"
  SSH_USER           = "root"
  code_server_domain = "code-${digitalocean_droplet.web.ipv4_address}.nip.io"
}

data "digitalocean_image" "codeserver" {
  name = "my-code-server"
}

// 1. Create new droplet
resource "digitalocean_droplet" "web" {
  image  = data.digitalocean_image.codeserver.id
  name   = local.web_server_name
  region = var.droplet_region
  size   = var.droplet_size
  ssh_keys = [
    data.digitalocean_ssh_key.digitalocean.id
  ]
}

// 2. Generate Ansible inventory file
resource "local_file" "inventory" {
  filename = "inventory.yml"
  content = templatefile("templates/inventory.yml.tpl", {
    RESOURCE_NAME        = digitalocean_droplet.web.name
    HOST_IP_ADDRESS      = digitalocean_droplet.web.ipv4_address
    SSH_USER             = local.SSH_USER
    PVT_KEY              = var.pvt_key
    code_server_password = var.code_server_password
    code_server_domain   = local.code_server_domain
  })
  file_permission = "0644"
}

resource "local_file" "root-at-droplet" {
  filename        = "root@${digitalocean_droplet.web.ipv4_address}"
  content         = ""
  file_permission = "0644"
}
