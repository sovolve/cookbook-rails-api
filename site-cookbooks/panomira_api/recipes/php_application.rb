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

  symlinks "chef_env_config.yaml" => "config/development.yaml"

  php do
    migration_command "bin/phpmig"

    local_settings_file "chef_env_config.yaml"
    settings_template "app_env_config.yaml.erb"

    database_master_role "php_mysql_master"
    database do
      find_matching_role("memcached", true) do |memcached_node|
        host = node_host memcached_node
        host = (host == node.ipaddress) ? 'localhost' : host

        memcached_host host
        memcached_port memcached_node.memcached.port
      end

      find_matching_role("php_neo4j_main", true) do |neo4j_main_node|
        host = node_host neo4j_main_node
        host = (host == node.ipaddress) ? 'localhost' : host

        neo4j_main_host host
        neo4j_main_port neo4j_main_node.neo4j.server.port
      end
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

def node_host(node)
  if node.attribute?('cloud')
    node['cloud']['local_ipv4']
  else
    node['ipaddress']
  end
end
