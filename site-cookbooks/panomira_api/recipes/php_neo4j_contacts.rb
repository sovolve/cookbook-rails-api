node.default['neo4j']['server']['name'] = 'neo4j-contacts'
node.default['neo4j']['server']['port'] = node['php_api']['neo4j']['contacts']['port']
node.default['neo4j']['server']['install_dir'] = "/usr/local/neo4j-server"
node.default['neo4j']['server']['lib_dir'] = "/var/lib/neo4j-server"
node.default['neo4j']['server']['conf_dir'] = "#{node['neo4j']['server']['install_dir']}/#{node['neo4j']['server']['name']}/conf"
node.default['neo4j']['server']['data_dir'] = "#{node['neo4j']['server']['install_dir']}/#{node['neo4j']['server']['name']}/data/graph.db"
node.default[:neo4j][:server][:lock_path] = "#{node[:neo4j][:server][:run_dir]}/#{node[:neo4j][:server][:name]}.lock"
node.default[:neo4j][:server][:pid_path] = "#{node[:neo4j][:server][:run_dir]}/#{node[:neo4j][:server][:name]}.pid"


include_recipe "neo4j-server::tarball"
