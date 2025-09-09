# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  #      _____             __ _
  #     / ____|           / _(_)
  #    | |     ___  _ __ | |_ _  __ _
  #    | |    / _ \| '_ \|  _| |/ _` |
  #    | |___| (_) | | | | | | | (_| |
  #     \_____\___/|_| |_|_| |_|\__, |
  #        Custom configuration  __/ |
  #                             |___/

  VMProvider = "virtualbox"
  # Change for "ubuntu/jammy64" if your machine is not arm
  Image = "bento/ubuntu-22.04"
  MasterPrivateIp = "192.168.1.2"
  NumberNodes = 2
  NodesPrivateIpPrefix = "192.168.2."
  PodNetworkCIDR = "10.1.0.0/16"
  # This is in case you are behind a firewall that changes your SSL certs, otherwise put it as false
  TLSCheckDisable = "true"


	config.vm.provision "shell", path: "scripts/machine-setup.sh", keep_color: true, args: [
    MasterPrivateIp,
    NumberNodes,
    NodesPrivateIpPrefix,
    TLSCheckDisable,
  ]

	# Define the master node
	config.vm.define "master" do |master|
		master.vm.box = Image
		master.vm.hostname = "master"
		master.vm.network "private_network", ip: MasterPrivateIp
		master.vm.provider VMProvider do |vb|
			vb.memory = "4096"
			vb.cpus = "2"
		end
		master.vm.provision "shell", path: "scripts/master.sh", keep_color: true, args: [
      PodNetworkCIDR,
      MasterPrivateIp,
      TLSCheckDisable,
    ]
    master.vm.box_download_insecure = TLSCheckDisable == "true"
	end

  # Define the worker nodes
  (1..NumberNodes).each do |i|
    config.vm.define "worker#{i}" do |worker|
      worker.vm.box = Image
      worker.vm.hostname = "worker#{i}"
      worker.vm.network "private_network", ip: "#{NodesPrivateIpPrefix}#{i+1}"
      worker.vm.provider VMProvider do |v|
        v.memory = "4096"
        v.cpus = "2"
      end
      worker.vm.provision "shell", path: "scripts/worker.sh"
      worker.vm.box_download_insecure = TLSCheckDisable == "true"
    end
  end
end
