#
# Cookbook Name:: panomira_rails_api
# Recipe:: nginx
#
# Copyright (C) 2013 Sovolve
# 
# All rights reserved - Do Not Redistribute
#

include_recipe "nginx"

nginx_site 'default' do
  enable false
end

template "#{node['nginx']['dir']}/sites-available/rails_api" do
  source 'nginx_site.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :reload, 'service[nginx]'
end

nginx_site "rails_api" do
  enable true
end
