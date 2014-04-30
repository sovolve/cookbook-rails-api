#
# Cookbook Name:: panomira_php_api
# Definition:: composer
#
# Copyright (C) 2013 Sovolve
# 
# All rights reserved - Do Not Redistribute
#

define :composer, shared_path: nil, release_path: nil, owner: nil, group: nil, action: :install do

  raise "The composer definition currently only understands the 'install' action!" unless params[:action] == :install

  Chef::Log.info 'Running composer install'

  directory "#{params[:shared_path]}/vendor" do
    owner params[:owner] if params[:owner]
    group params[:group] if params[:group]
    mode 0755
  end

  directory "#{params[:release_path]}/vendor" do
    action :delete
    recursive true
  end

  link "#{params[:release_path]}/vendor" do
    to "#{params[:shared_path]}/vendor"
  end

  execute "php composer.phar install -n -v" do
    cwd params[:release_path]
    user params[:owner] if params[:owner]
  end
end
