#
# Cookbook Name:: panomira_php_api
# Recipe:: apt_setup
#
# Copyright (C) 2013 Sovolve
# 
# All rights reserved - Do Not Redistribute
#

# PPA for PHP 5.5 (also unveils apache2 2.4...)
apt_repository "php5" do
  uri "http://ppa.launchpad.net/ondrej/php5/ubuntu"
  distribution node['lsb']['codename']
  components   ['main']
  keyserver    'keyserver.ubuntu.com'
  key          'E5267A6C'
end

# Another source for apache2 2.4 (it'd be much better if we could stick with 2.2 but it's problematic)
apt_repository "apache2" do
  uri "http://ppa.launchpad.net/ondrej/apache2/ubuntu"
  distribution node['lsb']['codename']
  components   ['main']
  keyserver    'keyserver.ubuntu.com'
  key          'E5267A6C'
end

# NOTE: installs PHP 5.4.x which is no longer acceptable
#
# apt_repository "php5-oldstable" do
#   uri "http://ppa.launchpad.net/ondrej/php5-oldstable/ubuntu"
#   distribution node['lsb']['codename']
#   components   ['main']
#   keyserver    'keyserver.ubuntu.com'
#   key          'E5267A6C'
# end
