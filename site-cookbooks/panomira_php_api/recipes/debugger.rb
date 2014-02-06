#
# Cookbook Name:: panomira_php_api
# Recipe:: debugger
#
# Copyright (C) 2013 Sovolve
# 
# All rights reserved - Do Not Redistribute
#
php_pear 'xdebug' do
  zend_extensions ['xdebug.so']
  directives(remote_autostart: 'on', remote_enable: 'on', remote_host: 'localhost', remote_port: '9000')
  action :install
  notifies :restart, "service[apache2]"
end

include_recipe "panomira_php_api::vim_debugger"
