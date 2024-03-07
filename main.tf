terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

# provider kubernetes added for later
provider "kubernetes" {
  config_path = var.kube_config_path
}

# decided to use Helm packages
provider "helm" {
  kubernetes {
    config_path = var.kube_config_path
  }
}

# digitalocean provider resource and token
provider "digitalocean" {
  token = var.do_token
}
resource "digitalocean_ssh_key" "terraform_ssh_key" {
  name       = "Terraform Example Key"
  public_key = file("${path.module}/files/terraform-ssh-key.pub")
}


# Create a new Web Droplet in the fra1 region
resource "digitalocean_droplet" "web" {
  count     = 3
  image     = "ubuntu-22-04-x64"
  name      = "terraformtest-${count.index}"
  region    = "fra1"
  size      = "s-2vcpu-2gb"
  ssh_keys  = [digitalocean_ssh_key.terraform_ssh_key.fingerprint]
  user_data = file("${path.module}/files/user-data.sh")

  # using SSH to connect and add the kubeconfig to bashrc ROOT
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "root"
      private_key = file("${path.module}/files/terraform-ssh-key")
      host        = self.ipv4_address
  
  }
  inline = [
    "echo 'export KUBECONFIG=/etc/kubernetes/admin.conf' >> /root/.bashrc",
    "source /root/.bashrc",
    "echo 'Kubeconfig contents:'",
    "cat /etc/kubernetes/admin.conf"
  ]
}
}
output "droplet_ips" {
  value = [for droplet in digitalocean_droplet.web : droplet.ipv4_address]
}
