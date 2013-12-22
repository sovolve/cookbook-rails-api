# -*- mode: ruby -*-
# vi: set ft=ruby :
site :opscode

metadata

cookbook "apt"
cookbook "git"
cookbook "build-essential"
cookbook "vim"
cookbook "curl", github: "phlipper/chef-curl"

cookbook "chef-solo-search"
cookbook "users"
cookbook "sudo"

cookbook "ssh", github: "markolson/chef-ssh"

cookbook "apache2"
cookbook "memcached"
cookbook "application"
cookbook "application_php"
cookbook "database"
cookbook "neo4j-multi-server", github: "sovolve/cookbook-neo4j-multi-server"

# This little bit of magick includes the cookbooks in the site-cookbooks directory too:
def dependencies(path)
  berks = "#{path}/Berksfile"
  instance_eval(File.read(berks)) if File.exists?(berks)
end

Dir.glob("#{File.expand_path(File.dirname(__FILE__))}/site-cookbooks/*").each do |path|
  dependencies path
  cookbook File.basename(path), :path => path
end
