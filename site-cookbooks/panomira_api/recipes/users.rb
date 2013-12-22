group node.php_api.group do
  action :create
end

user node.php_api.user do
  supports manage_home: true
  gid node.php_api.group
  shell "/bin/false"
  system true
  action [:create, :lock]
end

directory "/home/#{node.php_api.user}/.ssh" do
  owner node.php_api.user
  group node.php_api.group
  recursive true
end
