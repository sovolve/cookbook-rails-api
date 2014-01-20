#
# Cookbook Name:: panomira_rails_api
# Recipe:: hosts
#
# Copyright (C) 2013 Sovolve
# 
# All rights reserved - Do Not Redistribute
#
template "/etc/hosts" do
  source "hosts.erb"
  owner "root"
  group "root"
  mode 0644
  variables(
      :aliases => {"192.168.33.42" => ["php_api.development.panomira.com"]},
      :fqdn => node[:fqdn],
      :hostname => node[:hostname]
      )
end
