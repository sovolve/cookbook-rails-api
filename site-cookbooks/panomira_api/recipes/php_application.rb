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

  # Install php curl extension so that composer can run:
  packages ["php5-curl", "php5-mysql"]

  symlinks "chef_env_config.yaml" => "config/development.yaml"

  php do
    migration_command "bin/phpmig"

    local_settings_file "chef_env_config.yaml"
    settings_template "app_env_config.yaml.erb"

    database_master_role "php_mysql_master"
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
