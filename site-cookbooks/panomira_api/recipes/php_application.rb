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

  owner node.php_api.user
  group node.php_api.group

  repository node.php_api.repo
  revision node.php_api.revision

  migrate true
  enable_submodules true

  # Install php curl extension so that composer can run:
  packages ["php5-curl", "php5-mysql"]

  symlink_before_migrate "development.yaml" => "config/development.yaml"

  php do
    migration_command "./bin/phpmig migrate"
    write_settings_file false
    database_master_role "php_mysql_master"
  end

  # NOTE: This 'before_migrate' callback does a bunch of things, most of which are hacks because of
  # issues with the php_application cookbook. Then we need to run composer, which php_application is 
  # _supposed_ to support, but that seems to be broken right now. Lastly we put a template in place 
  # so the php_api app knows how to connect to the databases, memcached etc. php_application has 
  # basic support for this, but we wanted to extend it.
  # All of this could / should be refactored by either fixing / improving php_application cookbook, or moving
  # some of this stuff to definitions and / or resources.
  before_migrate do
    # Composer Hack:
    Chef::Log.info 'Running composer install'
    directory "#{new_resource.path}/shared/vendor" do
      owner new_resource.owner
      group new_resource.group
      mode 0755
    end
    directory "#{new_resource.release_path}/vendor" do
      action :delete
      recursive true
    end
    link "#{new_resource.release_path}/vendor" do
      to "#{new_resource.path}/shared/vendor"
    end
    execute "php composer.phar install -n -q" do
      cwd new_resource.release_path
      user new_resource.owner
    end

    # App template hack:
    Chef::Log.info "Creating development.yaml"
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

    neo4j_contacts = {}
    neo4j_contacts_node = begin
      role = "php_neo4j_contacts"
      if node['roles'].include? role
        node
      else
        search(:node, "role:#{role} AND chef_environment:#{node.chef_environment}").first
      end
    end
    neo4j_contacts[:host] =  begin
      raise "No neo4j_contacts node found!" unless neo4j_contacts_node
      host = if neo4j_contacts_node.attribute?('cloud')
        neo4j_contacts_node['cloud']['local_ipv4']
      else
        neo4j_contacts_node['ipaddress']
      end
      (host == node.ipaddress) ? 'localhost' : host
    end
    neo4j_contacts[:port] = neo4j_contacts_node.php_api.neo4j_contacts.port

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
      owner node.php_api.user
      group node.php_api.group
      mode "644"
      variables(
        :path => "#{new_resource.path}/current",
        :database => mysql_main,
        :memcached => memcached,
        :neo4j_main => neo4j_main,
        :neo4j_contacts => neo4j_contacts,
      )
    end
  end

  mod_php_apache2 do
    app_root "/httpdocs"
    webapp_template "web_app.conf.erb"
    webapp_overrides allow_override: "All"
  end
end
