# -*- mode: ruby -*-
# vi: set ft=ruby :
# encoding: utf-8

require 'bundler'
require 'bundler/setup'

class Panomira < Thor
  include Thor::Actions

  desc "go", "prepare, start, and provision the virtual machine(s)"
  def go (machines = :all)
    setup
    machines = validate_machines(machines)
    run "cd #{base_path} && bundle exec librarian-chef install" unless File.exist? "#{base_path}/cookbooks/panomira_php_api"
    unless vagrant_up? (machines)
      run "vagrant up #{machines}"
    end
  end

  desc "update", "update the virtual machine(s)"
  def update(machines = :all, restart = false)
    setup
    machines = validate_machines(machines)
    run "cd #{base_path} && git pull"
    run "cd #{base_path} && bundle exec librarian-chef install"
    if vagrant_up? machines
      if restart
        run "vagrant reload #{machines} --provision"
      else
        run "vagrant provision #{machines}"
      end
    else
      run "vagrant up #{machines} --provision"
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

  def setup
    ensure_data_bag_key
    vagrant_setup
  end

  def ensure_data_bag_key
    raise StandardError.new "You do not appear to have the data_bag_key. This key is NOT included in the repo, and must be sourced from either Alex W. or Gabe. It MUST be placed at the root of the cookbook-panomira-api-rails repository (where the README.md file is) and MUST be named data_bag_key, with no extension." unless File.exist? "#{base_path}/data_bag_key"
  end

  def vagrant_up? (machine_name = 'default')
    if machine_name
      `vagrant status #{machine_name}` =~ /running/
    else
      `vagrant status`.split("\n").each do |line|
        return false unless line =~ /running/
      end
      true
    end
  end

  def base_path
     File.expand_path(File.dirname(__FILE__))
  end

  def validate_machines(machines)
    if machines == :rails_api || machines == :all
      code_path = File.expand_path("../panomira-api-ror", File.dirname(__FILE__))
      unless File.directory? code_path
        puts "Vagrant expects a folder named 'panomira-api-ror' to exist paralell to this folder containing the checked out Ruby on Rails codebase (from https://github.com/sovolve/panomira-api-ror). Creating it now, but NOT checking out the code. That's up to you!"
        Dir.mkdir code_path
      end
    end

    if machines
      machines = machines.to_sym
      raise "Unknown parameter. You gave #{machines}, only 'all', 'php_api' and 'rails_api' are understood." unless [:all, :php_api, :rails_api].include? machines
      machines = nil if machines == :all # We don't need to do anything special, vagrant defaults to all machines.
    end
    machines
  end
end
