# -*- mode: ruby -*-
# vi: set ft=ruby :
# encoding: utf-8

require 'bundler'
require 'bundler/setup'

class Panomira < Thor
  include Thor::Actions

  desc "go", "prepare, start, and provision the virtual machine(s)"
  def go
    vagrant_setup # Setup vagrant first!
    run "cd #{base_path} && bundle exec librarian-chef install" unless File.exist? "#{base_path}/cookbooks/panomira_api"
    unless vagrant_up?
      run "vagrant up"
    end
  end

  desc "update", "update the virtual machine(s)"
  def update(restart = false)
    vagrant_setup
    run "cd #{base_path} && git pull"
    run "cd #{base_path} && bundle exec librarian-chef install"
    if vagrant_up?
      if restart
        run "vagrant reload --provision"
      else
        run "vagrant provision"
      end
    else
      run "vagrant up --provision"
    end
  end

  desc "stop", "shut down virtual machines"
  def stop
    run "vagrant halt"
  end

  desc "vagrant_setup", "install vagrant plugins"
  def vagrant_setup
    vagrant_path = `which vagrant`

    if vagrant_path.nil? || vagrant_path.empty?
      raise StandardError.new "Vagrant doesn't appear to be installed. Please install it from http://www.vagrantup.com/downloads.html"
    end

    # TODO: Terrible using system here, need to look @ thor more to
    # see what we can do to make this sane, or possibly use mxin::command?

    plugins = `vagrant plugin list`.split("\n").map { |i| i.split(" ")[0] }

    %w/vagrant-omnibus/.each do |plugin|
      run "vagrant plugin install #{plugin}" unless plugins.include? plugin
    end
  end

  private

  def vagrant_up?
    `vagrant status default` =~ /running/
  end

  def base_path
     File.expand_path(File.dirname(__FILE__))
  end
end
