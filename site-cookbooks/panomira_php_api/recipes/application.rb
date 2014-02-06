#
# Cookbook Name:: panomira_php_api
# Recipe:: application
#
# Copyright (C) 2013 Sovolve
# 
# All rights reserved - Do Not Redistribute
#

repo_host = node.php_api.repo.split("@").last.split(":").first
ssh_known_hosts repo_host do
    hashed false
end

# The environment string is used to run commands, name config files, etc. It can be over-ridden by setting
# an attribute, but defaults to the name of the currently running chef_environment.
environment_string = node["php_api"]["environment"] || node.chef_environment

# Lookup related nodes, and determine some information about them (mostly host & port)
# so that we can use them to configure the app.
memcached_node = node_by_role("memcached", environment_string)
memcached = {}
memcached[:host] = host_from_node memcached_node
memcached[:port] = memcached_node.memcached.port if memcached_node

neo4j_main_node = node_by_role("php_neo4j_main", environment_string)
neo4j_main = {}
neo4j_main[:host] = host_from_node neo4j_main_node
neo4j_main[:port] = neo4j_main_node.php_api.neo4j_main.port

neo4j_contacts_node = node_by_role("php_neo4j_contacts", environment_string) 
neo4j_contacts = {}
neo4j_contacts[:host] = host_from_node neo4j_contacts_node
neo4j_contacts[:port] = neo4j_contacts_node.php_api.neo4j_contacts.port

mysql_master_node = node_by_role("php_mysql_master", environment_string)
mysql_master = {}
mysql_master[:host] = host_from_node mysql_master_node 

include_recipe "panomira_php_api::apt_setup"
include_recipe "panomira_php_api::users"

application "php_api" do
  name node.php_api.subdomain
  path node.php_api.path

  owner node.php_api.user
  group node.php_api.group

  repository node.php_api.repo
  
  # We deploy from the master branch only to beta & production environments. We deploy from
  # develop everywhere else:
  revision node.php_api.revision || ((['production', 'beta'].include? environment_string) ? 'master' : 'develop')

  environment "SO_ENVIRONMENT" => environment_string

  migrate true
  enable_submodules true

  # NOTE: Packages to install (with package manager). These are set up to install php extensions,
  # and work on ubuntu. May need to change to support other platforms.
  packages ["php5-curl", "php5-mysql", "php5-memcached"]

  php do
    migration_command "./bin/phpmig migrate"
    write_settings_file false
    database_master_role "php_mysql_master"
    
    # Syslinks the environment specific config file (which will be created in the before_migrate callback) into
    # place, providing the PHP api with db, mysql, and neo4j connection info. NOTE: THis WILL overwrite
    # the config file present in the repo!
    symlink_before_migrate "#{environment_string}.yaml" => "config/#{environment_string}.yaml"
  end

  before_migrate do
    owner = new_resource.owner
    group = new_resource.group
    shared_path = "#{new_resource.path}/shared"
    release_path = new_resource.release_path

    # Definition, created by Alex, that runs composer install.
    composer do
      shared_path shared_path
      release_path release_path
      owner owner
      group group
      action :install
    end

    template "#{shared_path}/#{environment_string}.yaml" do
      source "app_env_config.yaml.erb"
      owner new_resource.owner
      group new_resource.group
      mode "644"
      # The variables passed in here are defined near the top of this
      # recipe.
      variables(
        :memcached => memcached,
        :neo4j_main => neo4j_main,
        :neo4j_contacts => neo4j_contacts,
        :database => mysql_master,
      )
    end
  end

  before_restart do
    service "mysql" do
      action :restart
    end
  end

  mod_php_apache2 do
    app_root "/httpdocs"
    webapp_template "web_app.conf.erb"
    webapp_overrides allow_override: "All"
  end
end

# Install & configure PHP debugger. Done AFTER the application is set up because
# the application installs PHP, and doing this before will bork on 'from scratch' builds.
include_recipe "panomira_php_api::debugger"

