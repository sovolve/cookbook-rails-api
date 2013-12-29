#
# Cookbook Name:: panomira_rails_api
# Recipe:: neo4j_contacts
#
# Copyright (C) 2013 Sovolve
# 
# All rights reserved - Do Not Redistribute
#

neo4j_server do
  instance_name 'rails_contacts'
  port node.rails_api.neo4j_contacts.port
end
