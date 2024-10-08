variable "jenkins_nodes" {
  type = number
}

variable "host_interface" {
  type = string
}

resource "virtualbox_vm" "node" {
  count     = var.jenkins_nodes
  name      = format("node-%02d", count.index + 1)
  image     = "https://app.vagrantup.com/ubuntu/boxes/focal64/versions/20240612.0.1/providers/virtualbox/unknown/vagrant.box"
  cpus      = 2
  memory    = "512 mib"
  user_data = file("${path.module}/user_data")

  network_adapter {
    type           = "bridged"
    host_interface = var.host_interface
  }

  connection {
    type        = "ssh"
    user        = "vagrant"
    host        = self.network_adapter[0].ipv4_address
    private_key = file("${path.module}/vagrant.key")
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update && sudo apt -y dist-upgrade",
      "sudo apt install -y openjdk-17-jdk openjdk-17-jdk-headless git wget curl unzip neovim",
    ]
  }
}



output "ip_adapters" {
  value = [for o in virtualbox_vm.node : o.network_adapter[0].ipv4_address]
}

