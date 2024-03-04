terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}


resource "digitalocean_ssh_key" "web" {
  name       = "eb app SSH key"
  public_key = file("${path.module}/files/id_rsa.pub")
}


# Create a new Web Droplet in the nyc2 region
resource "digitalocean_droplet" "web" {
  count     = 3
  image     = "ubuntu-22-04-x64"
  name      = "terraformtest-${count.index}"
  region    = "fra1"
  size      = "s-1vcpu-1gb"
  ssh_keys  = [digitalocean_ssh_key.web.id]
  user_data = file("${path.module}/files/user-data.sh")
}

resource "digitalocean_loadbalancer" "public" {
  name   = "terraformLB"
  region = "fra1"

  forwarding_rule {
    entry_port     = 80
    entry_protocol = "http"

    target_port     = 8080
    target_protocol = "http"
  }

  droplet_ids = digitalocean_droplet.web.*.id
}