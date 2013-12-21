# -*- mode: ruby -*-
# vi: set ft=ruby :
site :opscode

metadata

# This little bit of magick includes the cookbooks in the site-cookbooks directory too:
def dependencies(path)
  berks = "#{path}/Berksfile"
  instance_eval(File.read(berks)) if File.exists?(berks)
end

Dir.glob("#{File.expand_path(File.dirname(__FILE__))}/site-cookbooks/*").each do |path|
  dependencies path
  cookbook File.basename(path), :path => path
end
