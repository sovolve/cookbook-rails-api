#
# Cookbook Name:: panomira_php_api
# Recipe:: apt_setup
#
# Copyright (C) 2013 Sovolve
# 
# All rights reserved - Do Not Redistribute
#

apt_repository "php5-oldstable" do
  uri "http://ppa.launchpad.net/ondrej/php5-oldstable/ubuntu"
  distribution node['lsb']['codename']
  components   ['main']
  keyserver    'keyserver.ubuntu.com'
  key          'E5267A6C'
end
