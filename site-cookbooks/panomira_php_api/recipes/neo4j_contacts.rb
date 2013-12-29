#
# Cookbook Name:: panomira_php_api
# Recipe:: neo4j_contacts
#
# Copyright (C) 2013 Sovolve
# 
# All rights reserved - Do Not Redistribute
#

neo4j_server do
  instance_name 'php_contacts'
  port node.php_api.neo4j_contacts.port
end
