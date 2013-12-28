# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

# Which environment vagrant should use. Note that if you change this
# at least need to reprovision the servers, and _may_ need to re-create
# them from scratch. Also, both servers _should_ use the same environemnt,
# behaviour if both servers are using different environments is undefined.
ENVIRONMENT = "development"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  config.vm.hostname = "panomira-api-rails"

  config.vm.box = "opscode-ubuntu-12.04"
  config.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-12.04_chef-provisionerless.box"

  config.omnibus.chef_version = '11.6.0'

  config.vm.define "php_api" do |php_api|
    # Assign this VM to a host-only network IP, allowing you to access it
    # via the IP. Host-only networks can talk to the host machine as well as
    # any other machines on the same network, but cannot be accessed (through this
    # network interface) by any external networks.
    config.vm.network :private_network, ip: "192.168.33.42"
    config.ssh.forward_agent = false

    config.vm.provision :chef_solo do |chef|
      chef.encrypted_data_bag_secret_key_path = "#{File.expand_path(File.dirname(__FILE__))}/data_bag_key"
      chef.cookbooks_path = "cookbooks"
      chef.roles_path = "roles"
      chef.data_bags_path = "data_bags"
      chef.environments_path = "environments"

      # Vagrant VM's run in the "development" environment, which is configured
      # for local develelopment environments.
      chef.environment = ENVIRONMENT

      chef.add_role "vagrant_base" # Does vagrant specific config. Would be left off when provisioning a non-vagrant server.
      chef.add_role "php_single_server" # Loads the whole stack required to run the PHP API on one server.

      chef.json = {
        :mysql => {
          :server_root_password => 'rootpass',
          :server_debian_password => 'debpass',
          :server_repl_password => 'replpass'
        }
      }
    end
  end

  config.vm.define "rails_api" do |rails_api|
    # Assign this VM to a host-only network IP, allowing you to access it
    # via the IP. Host-only networks can talk to the host machine as well as
    # any other machines on the same network, but cannot be accessed (through this
    # network interface) by any external networks.
    config.vm.network :private_network, ip: "192.168.33.45"
    config.ssh.forward_agent = false

    config.vm.provision :chef_solo do |chef|
      chef.encrypted_data_bag_secret_key_path = "#{File.expand_path(File.dirname(__FILE__))}/data_bag_key"
      chef.cookbooks_path = "cookbooks"
      chef.roles_path = "roles"
      chef.data_bags_path = "data_bags"
      chef.environments_path = "environments"

      # Vagrant VM's run in the "development" environment, which is configured
      # for local develelopment environments.
      chef.environment = ENVIRONMENT

      chef.add_role "vagrant_base" # Does vagrant specific config. Would be left off when provisioning a non-vagrant server.
      chef.add_role "rails_single_server" # Loads the whole stack required to run the Rails API on one server.

      chef.json = {
        :mysql => {
          :server_root_password => 'rootpass',
          :server_debian_password => 'debpass',
          :server_repl_password => 'replpass'
        }
      }
    end
  end
end
