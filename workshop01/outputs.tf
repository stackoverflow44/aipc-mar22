output "do_fingerprint" {
  value = data.digitalocean_ssh_key.digitalocean.fingerprint
}

output "do_id" {
  value = data.digitalocean_ssh_key.digitalocean.id
}

output "dov-name" {
  value = docker_container.dov-bear-container[*].name
}

output "docker-container-host" {
  value = data.external.docker-host-ipaddr.result.ip
}

output "external-ports" {
  //value = docker_container.dov-bear-container[*].ports[*].external
  value = join(",", [for p in docker_container.dov-bear-container[*].ports[*] : element(p, 0).external])
}

output "nginx_ip" {
  value = digitalocean_droplet.web.ipv4_address
}
