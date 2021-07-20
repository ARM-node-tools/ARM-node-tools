# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-20.04"
  config.vm.synced_folder ".", "/home/vagrant/arm_node_tools"
  config.vm.provider "virtualbox" do |vb|
    vb.cpus = 2
    vb.memory = "5096"
  end
  config.vm.provision "shell", inline: <<-SHELL
    apt-get update
    apt-get install -y ruby ruby-dev rubygems build-essential
    gem install --no-document fpm
  SHELL
end