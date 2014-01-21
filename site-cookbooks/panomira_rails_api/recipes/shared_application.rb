#
# Cookbook Name:: panomira_rails_api
# Recipe:: shared_application
#
# Copyright (C) 2013 Sovolve
# 
# All rights reserved - Do Not Redistribute
#
# NOTE: This recipe sets up a server to run the Rails API
# in a "development" type environment. It assumes that the
# folder <node.rails_api.path>/current is shared with the host
# machine, and while it will checkout the repo if it's not already
# there, it will NOT update it if it already exists. It's assumed
# that you (the developer) will be making changes, switching branches
# etc from your development machine here. The code below is taken
# from the deployed_application recipe and from the official application
# and application_ruby cookbooks to configure nginx, unicorn, bundler
# and rvm to serve the app. It's kinda hacked together, and could probably
# be cleaned up, but it works.
#
# NOTE: Further note. This recipe does NOT run migrations! You need to
# do this manually be sshing into the server and running the appropriate
# commands. This is because in development you don't always want migrations
# run automagically.

repo_host = node.rails_api.repo.split("@").last.split(":").first
ssh_known_hosts repo_host do
    hashed false
end

# The environment string is used to run commands, name config files, etc. It can be over-ridden by setting
# an attribute, but defaults to the name of the currently running chef_environment.
environment_string = node["rails_api"]["environment"] || node.chef_environment
production_env = ['production', 'beta'].include? environment_string

# Lookup related nodes, and determine some information about them (mostly host & port)
# so that we can use them to configure the app.
memcached_node = node_by_role("memcached", environment_string)
memcached = {}
memcached[:host] = host_from_node memcached_node
memcached[:port] = memcached_node.memcached.port if memcached_node

neo4j_main_node = node_by_role("rails_neo4j_main", environment_string)
neo4j_main = {}
neo4j_main[:name] = 'main'
neo4j_main[:host] = host_from_node neo4j_main_node
neo4j_main[:port] = neo4j_main_node.rails_api.neo4j_main.port

neo4j_contacts_node = node_by_role("rails_neo4j_contacts", environment_string) 
neo4j_contacts = {}
neo4j_contacts[:name] = 'contacts'
neo4j_contacts[:host] = host_from_node neo4j_contacts_node
neo4j_contacts[:port] = neo4j_contacts_node.rails_api.neo4j_contacts.port

mysql_master_node = node_by_role("rails_db_master", environment_string)
mysql_master = {}
mysql_master[:host] = host_from_node mysql_master_node 

database_name = node.rails_api.database_name
db_username = node.rails_api.database_username
db_password = node.rails_api.database_password

include_recipe "runit"
include_recipe "rvm::system"
include_recipe "rvm::gem_package"
include_recipe "panomira_rails_api::nginx"

group node.rails_api.group do
  action :create
end


# This is a bit of a hack. It lets the vagrant user checkout the rails repo (if needed).
# Has to be the vagrant user (instead of the configured node.rails_api.user user) as it's
# assumed that the /current directory is being shared via vagrant, and vagrant imposes this
# limit on us :(.
git_key = Chef::EncryptedDataBagItem.load("git_keys", node.rails_api.user)
file "/home/vagrant/.ssh/id_rsa" do
  content git_key[:private_key]
end
file "/home/vagrant/.ssh/id_rsa.pub" do
  content git_key[:public_key]
end

directory "/var/log/unicorn" do
  user "vagrant"
  group node.rails_api.group
  mode 0755
end

directory "#{node.rails_api.path}/shared" do
  user "vagrant"
  group node.rails_api.group
  mode 0755
end

rvm_gem "bundler" do
  version "1.5.1"
end

git "#{node.rails_api.path}/current" do
  user "vagrant"
  group node.rails_api.group
  repository node.rails_api.repo
  revision "develop" # It always checks out the develop branch.
  action :checkout
end

directory "#{node.rails_api.path}/current/vendor/gems" do
  user "vagrant"
  group node.rails_api.group
  mode 0755
end

template "#{node.rails_api.path}/shared/neo4j.yml" do
  source "neo4j.yml.erb"
  mode 0644
  owner "vagrant"
  group node.rails_api.group
  variables ({
    :rails_env => environment_string,
    :servers => [neo4j_main, neo4j_contacts],
  })
end

template "#{node.rails_api.path}/shared/database.yml" do
  source "database.yml.erb"
  mode 0644
  owner "vagrant"
  group node.rails_api.group
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

template "#{node.rails_api.path}/shared/memcached.yml" do
  cookbook "application_ruby"
  source "memcached.yml.erb"
  mode 0644
  owner "vagrant"
  group node.rails_api.group
  variables ({
    :env => environment_string,
    :hosts => [memcached_node],
    :options => {},
  })
end

link "#{node.rails_api.path}/current/config/database.yml" do
  to "#{node.rails_api.path}/shared/database.yml"
  mode 0644
  owner "vagrant"
  group node.rails_api.group
end

link "#{node.rails_api.path}/current/config/memcached.yml" do
  to "#{node.rails_api.path}/shared/memcached.yml"
  mode 0644
  owner "vagrant"
  group node.rails_api.group
end

link "#{node.rails_api.path}/current/config/neo4j.yml" do
  to "#{node.rails_api.path}/shared/neo4j.yml"
  mode 0644
  owner "vagrant"
  group node.rails_api.group
end

Chef::Log.info "Running bundle install"
bundle_command = "/usr/local/rvm/bin/rvm-auto-ruby #{node.rvm.root_path}/gems/ruby-#{node.rvm.gem_package.rvm_string}/bin/bundle"
execute "#{bundle_command} install --path=vendor/gems" do
  cwd "#{node.rails_api.path}/current"
  user "vagrant"
  environment "SO_ENVIRONMENT" => environment_string, "RAILS_ENV" => environment_string
end

include_recipe "unicorn"

unicorn_config "/etc/unicorn/rails_api.rb" do
  working_directory "#{node.rails_api.path}/current"
  listen "/tmp/unicorn.sock" => {}
  forked_user "vagrant"
  forked_group node.rails_api.group
  worker_processes production_env ? 5 : 1
  stdout_path "/var/log/unicorn/stdout.log"
  stderr_path "/var/log/unicorn/stderr.log"
  preload_app production_env
  if production_env
    # Before fork / after fork stuff should go here for no downtime deploys.
  end
  notifies :restart, "runit_service[rails_api]"
end

node.default["rails_api"]["owner"] = "vagrant"
node.default["rails_api"]["application"]["name"] = "rails_api"
runit_service "rails_api" do
  run_template_name 'unicorn'
  log_template_name 'unicorn'
  owner "vagrant"
  group node.rails_api.group
  env "HOME" => "/home/vagrant", "RAILS_ENV" => environment_string

  options(
    :app => node.rails_api,
    :bundler => true,
    :bundle_command => bundle_command,
    :rails_env => environment_string,
    :smells_like_rack => ::File.exists?(::File.join(node.rails_api.path, "current", "config.ru"))
  )
end

# This actually restarts unicorn:
execute "/etc/init.d/rails_api hup" do
  user "root"
end
