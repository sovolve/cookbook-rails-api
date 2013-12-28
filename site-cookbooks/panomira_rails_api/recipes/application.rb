#
# Cookbook Name:: panomira_rails_api
# Recipe:: application
#
# Copyright (C) 2013 Sovolve
# 
# All rights reserved - Do Not Redistribute
#

repo_host = node.rails_api.repo.split("@").last.split(":").first
ssh_known_hosts repo_host do
    hashed false
end

# The environment string is used to run commands, name config files, etc. It can be over-ridden by setting
# an attribute, but defaults to the name of the currently running chef_environment.
environment_string = node["rails_api"]["environment"] || node.chef_environment

# Lookup related nodes, and determine some information about them (mostly host & port)
# so that we can use them to configure the app.
memcached_node = node_by_role("memcached", environment_string)
memcached = {}
memcached[:host] = host_from_node memcached_node
memcached[:port] = memcached_node.memcached.port if memcached_node

neo4j_main_node = node_by_role("rails_neo4j_main", environment_string)
neo4j_main = {}
neo4j_main[:host] = host_from_node neo4j_main_node
neo4j_main[:port] = neo4j_main_node.rails_api.neo4j_main.port

neo4j_contacts_node = node_by_role("rails_neo4j_contacts", environment_string) 
neo4j_contacts = {}
neo4j_contacts[:host] = host_from_node neo4j_contacts_node
neo4j_contacts[:port] = neo4j_contacts_node.rails_api.neo4j_contacts.port

mysql_master_node = node_by_role("rails_db_master", environment_string)
mysql_master = {}
mysql_master[:host] = host_from_node mysql_master_node 

include_recipe "panomira_rails_api::users"
include_recipe "rvm::system"
include_recipe "rvm::gem_package"

application "rails_api" do
  name node.rails_api.subdomain
  path node.rails_api.path

  owner node.rails_api.user
  group node.rails_api.group

  repository node.rails_api.repo
  
  # We deploy from the master branch only to beta & production environments. We deploy from
  # develop everywhere else:
  revision (['production', 'beta'].include? environment_string) ? 'master' : 'develop'

  environment "SO_ENVIRONMENT" => environment_string

  migrate true
  enable_submodules true
end
