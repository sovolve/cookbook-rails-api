#
# Cookbook Name:: panomira_rails_api
# Recipe:: database_setup
#
# Copyright (C) 2013 Sovolve
# 
# All rights reserved - Do Not Redistribute
#

connection_info = {:host => "localhost", :username => 'root', :password => node['mysql']['server_root_password']}

execute "create table #{node.rails_api.database_name}" do
  command "mysql -u#{connection_info[:username]} -p#{connection_info[:password]} -e 'CREATE DATABASE IF NOT EXISTS #{node.rails_api.database_name}'"
end

execute "create users in database #{node.rails_api.database_name}" do
  %W{ % #{node['ipaddress']} #{node['fqdn']} localhost }.each do |h|
    command "mysql -u#{connection_info[:username]} -p#{connection_info[:password]} -e 'grant usage on #{node.rails_api.database_name}.* to #{node.rails_api.database_username}@#{h} identified by \"#{node.rails_api.database_password}\";'"
  end
end
