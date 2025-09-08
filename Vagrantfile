# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|

  # Change for "ubuntu/jammy64" if your machine is not arm
  Image = "bento/ubuntu-22.04"
	MasterPrivateIp = "192.168.1.1"
	NumberNodes = 2
	NodesPrivateIpPrefix = "192.168.2."
	PodNetworkCIDR = "10.1.0.0/16"

	config.vm.provision "shell", path: "scripts/machine-setup.sh", keep_color: true, args: [
    MasterPrivateIp,
    NumberNodes,
    NodesPrivateIpPrefix
  ]

	# Define the master node
	config.vm.define "master" do |master|
		master.vm.box = Image
		master.vm.hostname = "master"
		master.vm.network "private_network", ip: MasterPrivateIp
		master.vm.provider "virtualbox" do |vb|
			vb.memory = "4096"
			vb.cpus = "2"
		end
		master.vm.provision "shell", path: "scripts/master.sh", keep_color: true, args: PodNetworkCIDR
	end
end
