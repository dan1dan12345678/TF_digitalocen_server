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
  name       = "web app SSH key"
  public_key = file("${path.module}/files/id_rsa.pub")
}


# Create a new Web Droplet in the fra1 region
resource "digitalocean_droplet" "web" {
  count     = 1
  image     = "ubuntu-22-04-x64"
  name      = "terraformtest-${count.index}"
  region    = "fra1"
  size      = "s-2vcpu-2gb"
  ssh_keys  = [digitalocean_ssh_key.web.id]
  user_data = file("${path.module}/files/user-data.sh")
}

output "droplet_ips" {
  value = [for droplet in digitalocean_droplet.web : droplet.ipv4_address]
}

# provider kubernetes added for later
provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

# decided to use Helm packages

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}
