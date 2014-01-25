#
# Cookbook Name:: panomira_rails_api
# Recipe:: osx_application
#
# Copyright (C) 2013 Sovolve
# 
# All rights reserved - Do Not Redistribute
#

include_recipe "panomira_rails_api::database_setup"

base_path = File.expand_path(node.rails_api.path)

environment_string = "development"
memcached = { 'ipaddress' => 'localhost', 'memcached' => {'port' => 11211 }}

neo4j_main = { name: 'main', host: 'localhost', port: 7474 }
neo4j_contacts = { name: 'contacts', host: 'localhost', port: 7474 }

mysql_master = { host: 'localhost' }

database_name = node.rails_api.database_name
db_username = node.rails_api.database_username
db_password = node.rails_api.database_password

git "#{base_path}" do
  user node['current_user']
  repository node.rails_api.repo
  revision "develop" # It always checks out the develop branch.
  action :checkout
end

template "#{base_path}/config/neo4j.yml" do
  source "neo4j.yml.erb"
  mode 0644
  user node['current_user']
  variables ({
    :rails_env => environment_string,
    :servers => [neo4j_main, neo4j_contacts],
  })
end

template "#{base_path}/config/database.yml" do
  source "database.yml.erb"
  mode 0644
  user node['current_user']
  variables ({
    :rails_env => environment_string,
    :host => mysql_master[:host],
    :database => {
      "adapter" => "mysql2",
      "database" => database_name,
      "username" => db_username,
      "password" => db_password,
    },
  })
end

template "#{base_path}/config/memcached.yml" do
  cookbook "application_ruby"
  source "memcached.yml.erb"
  mode 0644
  user node['current_user']
  variables ({
    :env => environment_string,
    :hosts => [memcached],
    :options => {},
  })
end

Chef::Log.info "Running bundle install"
bundle_command = "bundle"
execute "#{bundle_command} install" do
  cwd "#{base_path}"
  user node['current_user']
  environment "SO_ENVIRONMENT" => environment_string, "RAILS_ENV" => environment_string
end
