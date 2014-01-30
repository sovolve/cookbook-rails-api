#
# Cookbook Name:: panomira_php_api
# Recipe:: database_setup
#
# Copyright (C) 2013 Sovolve
# 
# All rights reserved - Do Not Redistribute
#

connection_info = {:host => "localhost", :username => 'root', :password => node['mysql']['server_root_password']}

execute "create table #{node.php_api.database_name}" do
  command "mysql -u#{connection_info[:username]} -p#{connection_info[:password]} -e 'CREATE DATABASE IF NOT EXISTS #{node.php_api.database_name}'"
end

hosts = %W{ % #{node['ipaddress']} #{node['fqdn']} localhost }
if ["development", "php_api_test"].include? node.chef_environment
  hosts << "192.168.33.45"
end

hosts.each do |h|
  execute "create users in database #{node.php_api.database_name} with access from host #{h}" do
    command "mysql -u#{connection_info[:username]} -p#{connection_info[:password]} -e 'grant all on #{node.php_api.database_name}.* to #{node.php_api.database_username}@\"#{h}\" identified by \"#{node.php_api.database_password}\";'"
  end
end
