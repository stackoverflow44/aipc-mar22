variable DO_token{
    type = string 
    description = "Digital Oceean Token"
}

variable droplet_image{
    type = string
    default = "ubuntu-20-04-x64"
}

variable droplet_size{
    type =string
    default ="s-1vcpu-2gb"
}

variable droplet_region{
    type = string
    default = "sgp1"
}

source digitalocean mydroplet {
    api_token = var.DO_token
    region = var.droplet_region
    image = var.droplet_image
    size = var.droplet_size
    snapshot_name = "my-code-server"
    ssh_username = "root"
}

build {
    sources = [
        "source.digitalocean.mydroplet"
    ]

    provisioner ansible {
        playbook_file = "playbook.yml"
    }
}