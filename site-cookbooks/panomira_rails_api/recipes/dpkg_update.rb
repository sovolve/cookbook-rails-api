# Cookbook Name:: panomira_rails_api
# Recipe:: dpkg_update
#
# Copyright (C) 2013 Sovolve
# 
# All rights reserved - Do Not Redistribute
#
if node[:platform_family].include? "debian"
  package "dpkg" do
    action :upgrade
  end
end
