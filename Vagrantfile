# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  config.vm.hostname = "panomira-api-rails"

  config.vm.box = "opscode-ubuntu-12.04"
  config.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-12.04_chef-provisionerless.box"

  config.omnibus.chef_version = '11.6.0'

  # Assign this VM to a host-only network IP, allowing you to access it
  # via the IP. Host-only networks can talk to the host machine as well as
  # any other machines on the same network, but cannot be accessed (through this
  # network interface) by any external networks.
  config.vm.network :private_network, ip: "192.168.33.42"
  config.ssh.forward_agent = true

  # Configure berkshelf:
  config.berkshelf.berksfile_path = "#{File.expand_path(File.dirname(__FILE__))}/Berksfile"
  config.berkshelf.enabled = true

  config.vm.provision :chef_solo do |chef|
    chef.encrypted_data_bag_secret_key_path = "#{File.expand_path(File.dirname(__FILE__))}/data_bag_key"
    chef.roles_path = "roles"
    chef.data_bags_path = "data_bags"
    chef.environments_path = "environments"
    chef.environment = "local_dev"

    # Includes chef-solo search, which is used by the user recipe. This
    # _must_ be before the roles, so that it's run first, otherwise it
    # won't be available to all recipes.
    chef.add_recipe "chef-solo-search"

    chef.add_role "vm_base" # Specific role for VM's, sets up users, permissions etc.
    chef.add_role "php_mysql_master"
    chef.add_role "php_webserver"

    chef.json = {
      :mysql => {
        :server_root_password => 'rootpass',
        :server_debian_password => 'debpass',
        :server_repl_password => 'replpass'
      }
    }
  end
end
