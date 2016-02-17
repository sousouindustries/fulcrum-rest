# -*- mode: ruby -*-
# vi: set ft=ruby ts=2 sw=2:

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "ubuntu/trusty64"
  #config.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/wily/current/wily-server-cloudimg-amd64-vagrant-disk1.box"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network :forwarded_port, guest: 80, host: 8080

  config.vm.network :private_network, ip: "192.168.33.10" # Fulcrum API
  config.vm.network :private_network, ip: "192.168.33.11" # WebUI and API
  config.vm.network :private_network, ip: "192.168.33.12" # ESB
  config.vm.network :private_network, ip: "192.168.33.13" # Message broker
  config.vm.network :private_network, ip: "192.168.33.14" # PostgreSQL database
  config.vm.network :private_network, ip: "192.168.33.15" # Origin
  config.vm.network :private_network, ip: "192.168.33.16" # Sousou IPS


  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network :public_network

  # If true, then any SSH connections made will enable agent forwarding.
  # Default value: false
  config.ssh.forward_agent = true

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  config.vm.provider :virtualbox do |vb|
    vb.gui = false
    vb.customize ["modifyvm", :id, "--memory", "4096"]
    vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
  end

end
