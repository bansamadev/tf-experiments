variable "puppet_nodes" {
  type = number
}

variable "host_interface" {
  type = string
}

resource "virtualbox_vm" "node" {
  count     = var.puppet_nodes
  name      = format("puppet-node-%02d", count.index + 1)
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
      "sudo apt install -y git wget curl unzip neovim",
      "wget https://apt.puppet.com/puppet-release-focal.deb",
      "wget https://apt.puppet.com/puppet-tools-release-focal.deb",
      "sudo dpkg -i puppet-release-focal.deb && sudo dpkg -i https://apt.puppet.com/puppet-tools-release-focal.deb",
      "sudo apt update && sudo apt install -y puppet-agent",
      "sudo hostname ${format("puppet-node-%02d", count.index + 1)}"
    ]
  }
}

resource "virtualbox_vm" "server" {
  name      = "puppet-server"
  image     = "https://app.vagrantup.com/ubuntu/boxes/focal64/versions/20240612.0.1/providers/virtualbox/unknown/vagrant.box"
  cpus      = 2
  memory    = "4096 mib"
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
      "wget https://apt.puppet.com/puppet-release-focal.deb",
      "wget https://apt.puppet.com/puppet-tools-release-focal.deb",
      "sudo dpkg -i puppet-release-focal.deb && sudo dpkg -i https://apt.puppet.com/puppet-tools-release-focal.deb",
      "sudo apt update && sudo apt install -y puppetserver",
      "sudo hostname puppet-server"
    ]
  }
}

output "ip_adapters" {
  value = [for o in concat(tolist(virtualbox_vm.node), tolist([virtualbox_vm.server])) : o.network_adapter[0].ipv4_address]
}

