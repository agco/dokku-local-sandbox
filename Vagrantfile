# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end

  config.vm.box = "ubuntu/trusty64"
  config.vm.network "private_network", ip: "10.0.0.2"
  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--ostype", "Ubuntu_64"]
    vb.customize ["modifyvm", :id, "--memory", "1024"]
  end

  config.vm.provision "shell" do |s|
    s.path = "provision.sh"
    s.args = "#{ENV['LOGSPOUT_SYSLOG_URL']}"
  end

end
