data "digitalocean_ssh_key" "digitalocean" {
  name = "digitalocean"
}

// get ip address of docker host 
data "external" "docker-host-ipaddr" {
  program = ["bash", "-c", "curl -s 'https://api.ipify.org?format=json'"]
}

// store local variables
locals {
  web_server_name = "nginx-1"
  docker_host_ip  = data.external.docker-host-ipaddr.result.ip
}

// 1. Create image
resource "docker_image" "dov-bear" {
  name         = "chukmunnlee/dov-bear:v2"
  keep_locally = true
}

// 2. Start containers
resource "docker_container" "dov-bear-container" {
  count = var.do_instance_count
  name  = "dov-bear-${count.index}"
  image = docker_image.dov-bear.latest

  ports {
    internal = "3000"
    # external = "8080"
  }

  env = [
    "INSTANCE_NAME=dov-${count.index}"
  ]
}

// 3. Generate nginx.conf base on docker container ip and ports
resource "local_file" "nginx_conf" {
  filename = "nginx.conf"
  content = templatefile("templates/nginx.conf.tpl", {
    docker_host_ip  = local.docker_host_ip
    container_ports = [for p in docker_container.dov-bear-container[*].ports[*] : element(p, 0).external]
  })
  file_permission = "0644"
}


// 4. Create a new Web Droplet in the sgp1 region
resource "digitalocean_droplet" "web" {
  image  = var.droplet_image
  name   = local.web_server_name
  region = var.droplet_region
  size   = var.droplet_size
  ssh_keys = [
    data.digitalocean_ssh_key.digitalocean.id
  ]

  //setup ssh conneciton
  connection {
    host        = self.ipv4_address
    user        = "root"
    type        = "ssh"
    private_key = file(var.pvt_key)
    timeout     = "2m"
  }

  //install nginx
  provisioner "remote-exec" {
    inline = [
      "apt update",
      "apt install -y nginx"
    ]
  }

  //copy and replace nginx configurations
  provisioner "file" {
    source      = "./nginx.conf"
    destination = "/etc/nginx/nginx.conf"
  }

  // Restart nginx cause we have updated the configuration
  provisioner "remote-exec" {
    inline = [
      "systemctl restart nginx"
    ]
  }

}

resource "local_file" "root-at-droplet" {
  filename        = "root@${digitalocean_droplet.web.ipv4_address}"
  content         = ""
  file_permission = "0644"
}
