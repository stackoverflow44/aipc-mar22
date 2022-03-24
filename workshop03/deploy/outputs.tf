output "host-name" {
  value = digitalocean_droplet.web.name
}

output "host_ip_address" {
  value = digitalocean_droplet.web.ipv4_address
}

output "code-server-domain" {
  value = local.code_server_domain
}

