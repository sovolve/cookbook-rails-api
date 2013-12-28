# Cookbook Name:: panomira_rails_api
# Recipe:: apt_setup
#
# Copyright (C) 2013 Sovolve
# 
# All rights reserved - Do Not Redistribute
#

group node.rails_api.group do
  action :create
end

user node.rails_api.user do
  supports manage_home: true
  gid node.rails_api.group
  shell "/bin/false"
  system true
  action [:create, :lock]
end

directory "/home/#{node.rails_api.user}/.ssh" do
  owner node.rails_api.user
  group node.rails_api.group
  recursive true
end

git_key = Chef::EncryptedDataBagItem.load("git_keys", node.rails_api.user)
file "/home/#{node.rails_api.user}/.ssh/id_rsa" do
  content git_key[:private_key]
end
file "/home/#{node.rails_api.user}/.ssh/id_rsa.pub" do
  content git_key[:public_key]
end
