# see which version of PHP is required in composer.json file in PHP API root
#   [look for "require": {"php": ">= 5.5.4", <...>}"]

# note: to reinstall: sudo apt-get -o DPkg::Options::="--force-confmiss" --reinstall install apache2 -y

directory node['php']['ext_conf_dir'] do
  owner 'root'
  group 'root'
  mode '0755'
  recursive true
end

include_recipe "panomira_php_api::apt_setup"

execute 'apt-get update' do
  command "apt-get update -y"
  action :nothing
end

execute 'apt-get purge' do
  command "apt-get purge #{(node['php']['packages'] + %w(apache2)).join(" ")} -y"
  action :nothing
end

include_recipe "php::package"
include_recipe "apache2"

(node['php']['packages'] + %w(apache2)).each do |pkg|
  package pkg do
    action :upgrade
  end
end