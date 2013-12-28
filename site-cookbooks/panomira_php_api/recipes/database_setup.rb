#
# Cookbook Name:: panomira_php_api
# Recipe:: database_setup
#
# Copyright (C) 2013 Sovolve
# 
# All rights reserved - Do Not Redistribute
#

include_recipe "database::mysql"

connection_info = {:host => "localhost", :username => 'root', :password => node['mysql']['server_root_password']}

mysql_database "create #{node.php_api.database_name}" do
  database_name node.php_api.database_name
  connection connection_info
  action :create
end

%W{ % #{node['ipaddress']} #{node['fqdn']} localhost }.each do |h|
  mysql_database_user node.php_api.database_username do
    connection connection_info
    password node.php_api.database_password
    database_name node.php_api.database_name
    host h
    action :grant
  end
end
