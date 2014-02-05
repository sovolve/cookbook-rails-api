#
# Cookbook Name:: panomira_php_api
# Recipe:: vim_config
#
# Copyright (C) 2013 Sovolve
# 
# All rights reserved - Do Not Redistribute
#

directory "/usr/share/vim/vim73/plugin" do
  action :create
end

cookbook_file "/usr/share/vim/vim73/plugin/dbgpavim.py" do
  source "dbgpavim.py"
end

cookbook_file "/usr/share/vim/vim73/plugin/dbgpavim.vim" do
  source "dbgpavim.vim"
end
