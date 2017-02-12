Vagrant.configure("2") do |config|
	config.vm.box = "bento/ubuntu-16.04"
	config.vm.provision :shell, :path => "scripts/setup.sh"
	config.ssh.insert_key = true
	config.vm.synced_folder '.', '/vagrant', disabled: false, type: "nfs"

	# Assign this VM to a host-only network IP, allowing you to access it
	# via the IP. Host-only networks can talk to the host machine as well as
	# any other machines on the same network, but cannot be accessed (through this
	# network interface) by any external networks.
#	config.vm.network :private_network, ip: "192.168.3.3"
	config.vm.network :forwarded_port, host: 8080, guest: 8080
	config.vm.network :forwarded_port, host: 9000, guest: 9000

	# Set the Timezone to Europe/Sofia
	config.vm.provision :shell, :inline => "echo \"Europe/Sofia\" | sudo tee /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata"

	config.vm.provider :virtualbox do |vb|
		vb.gui = true
		# Use VBoxManage to customize the VM. For example to change memory:
		vb.customize ["modifyvm", :id, "--name", "php-devbox"]
		vb.customize ["modifyvm", :id, "--memory", "8192"]
		vb.customize ["modifyvm", :id, "--vram", 128]
		vb.customize ["modifyvm", :id, "--cpus", 4]
		vb.customize ["modifyvm", :id, "--accelerate3d", "on"]
		vb.customize ['modifyvm', :id, '--clipboard', 'bidirectional']
		vb.customize ['modifyvm', :id, '--draganddrop', 'bidirectional']
	end

end
