#
# Cookbook Name:: panomira_api
# Recipe:: php_application
#
# Copyright (C) 2013 Sovolve
# 
# All rights reserved - Do Not Redistribute
#

repo_host = node.php_api.repo.split("@").last.split(":").first
ssh_known_hosts repo_host do
    hashed false
end

application "php_api" do
  name node.php_api.subdomain
  path node.php_api.path
  #owner node.php_api.user
  #group node.php_api.group

  repository node.php_api.repo
  revision node.php_api.revision

  #migrate true
  enable_submodules true

  # Appears to support composer out of the box?
  # TODO: Test, try to use.
  #composer true
  #composer_command "php composer.phar"

  # Install php curl extension so that composer can run:
  packages ["php5-curl", "php5-mysql"]

  symlinks "development.yaml" => "config/development.yaml"

  php do
    migration_command "bin/phpmig"
    write_settings_file false

    database_master_role "php_mysql_master"
    database do
      #neo4j_main_host neo4j_main_host
      #neo4j_main_port neo4j_main_node.neo4j.server.port
    end
  end

  before_migrate do
    memcached = {}
    memcached_node = begin
      role = "php_memcached"
      if node['roles'].include? role
        node
      else
        search(:node, "role:#{role} AND chef_environment:#{node.chef_environment}").first
      end
    end
    memcached[:host] =  begin
      raise "No memcached node found!" unless memcached_node
      host = if memcached_node.attribute?('cloud')
        memcached_node['cloud']['local_ipv4']
      else
        memcached_node['ipaddress']
      end
      (host && host == node.ipaddress) ? 'localhost' : host
    end
    memcached[:port] = memcached_node.memcached.port

    neo4j_main = {}
    neo4j_main_node = begin
      role = "php_neo4j_main"
      if node['roles'].include? role
        node
      else
        search(:node, "role:#{role} AND chef_environment:#{node.chef_environment}").first
      end
    end
    neo4j_main[:host] =  begin
      raise "No neo4j_main node found!" unless neo4j_main_node
      host = if neo4j_main_node.attribute?('cloud')
        neo4j_main_node['cloud']['local_ipv4']
      else
        neo4j_main_node['ipaddress']
      end
      (host == node.ipaddress) ? 'localhost' : host
    end
    neo4j_main[:port] = neo4j_main_node.php_api.neo4j_main.port

    mysql_main = {}
    mysql_main_node = begin
      role = "php_mysql_master"
      if node['roles'].include? role
        node
      else
        search(:node, "role:#{role} AND chef_environment:#{node.chef_environment}").first
      end
    end
    mysql_main[:host] =  begin
      raise "No php_myql_master node found!" unless mysql_main_node
      host = if mysql_main_node.attribute?('cloud')
        mysql_main_node['cloud']['local_ipv4']
      else
        mysql_main_node['ipaddress']
      end
      (host == node.ipaddress) ? 'localhost' : host
    end
    mysql_main[:port] = mysql_main_node.mysql.port

    template "#{new_resource.path}/shared/development.yaml" do
      source "app_env_config.yaml.erb"
      owner new_resource.owner
      group new_resource.group
      mode "644"
      variables(
        :path => "#{new_resource.path}/current",
        :database => mysql_main,
        :memcached => memcached,
        :neo4j_main => neo4j_main,
      )
    end
  end

  before_symlink do
    directory node.php_api.path do
      owner node.php_api.user
      group node.php_api.group
      recursive true
    end
    execute "fix_permissions" do
      command "chown -R #{node.php_api.user}:#{node.php_api.group} #{node.php_api.path}"
      cwd node.php_api.path
    end
  end

  before_restart do
    execute 'php composer.phar install' do
      cwd "#{node.php_api.path}/current"
      user node.php_api.user
      group node.php_api.group
    end
  end

  mod_php_apache2 do
    app_root "/httpdocs"
    webapp_template "web_app.conf.erb"
    webapp_overrides allow_override: "All"
  end
end

#def find_matching_role(role, single=true, &block)
  #return nil if !role
  #nodes = []
  #if node['roles'].include? role
    #nodes << node
  #end
  #if !single || nodes.empty?
    #search(:node, "role:#{role} AND chef_environment:#{node.chef_environment}") do |n|
      #nodes << n
    #end
  #end
  #if block
    #nodes.each do |n|
      #yield n
    #end
  #else
    #if single
      #nodes.first
    #else
      #nodes
    #end
  #end
#end

def node_host(node)
  if node.attribute?('cloud')
    node['cloud']['local_ipv4']
  else
    node['ipaddress']
  end
end
