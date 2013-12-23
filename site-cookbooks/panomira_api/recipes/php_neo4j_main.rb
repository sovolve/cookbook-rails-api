#
# Cookbook Name:: panomira_api
# Recipe:: php_neo4j_main
#
# Copyright (C) 2013 Sovolve
# 
# All rights reserved - Do Not Redistribute
#

neo4j_server do
  instance_name 'main'
  port node.php_api.neo4j_main.port
end
