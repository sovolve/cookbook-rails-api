#
# Cookbook Name:: panomira_php_api
# Recipe:: vim_debugger
#
# Copyright (C) 2013 Sovolve
# 
# All rights reserved - Do Not Redistribute
#

directory "/usr/share/vim/vim73/plugin" do
  action :create
end

cookbook_file "/usr/share/vim/vim73/plugin/vdebug.vim" do
  source "vdebug.vim"
end

remote_directory "/usr/share/vim/vim73/plugin/python" do
  source "python"
end

cookbook_file "/usr/share/vim/vim73/plugin/start_vdebug.py" do
  source "python/start_vdebug.py"
end

remote_directory "/usr/share/vim/vim73/plugin/vdebug" do
  source "python/vdebug"
end
