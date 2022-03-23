output "do_fingerprint" {
  value = data.digitalocean_ssh_key.digitalocean.fingerprint
}

output "do_id" {
  value = data.digitalocean_ssh_key.digitalocean.id
}

output "host-name" {
  value = digitalocean_droplet.web.name
}

output "host_ip_address" {
  value = digitalocean_droplet.web.ipv4_address
}


