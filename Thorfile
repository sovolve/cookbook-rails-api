# -*- mode: ruby -*-
# vi: set ft=ruby :
# encoding: utf-8

require 'bundler'
require 'bundler/setup'
require 'berkshelf/thor'

class ConcertHunt < Thor
  include Thor::Actions

  desc "vagrant_setup", "install vagrant plugins"
  def vagrant_setup
    vagrant_path = `which vagrant`

    if vagrant_path.nil? || vagrant_path.empty?
      raise StandardError.new "Vagrant doesn't appear to be installed. Please install it from http://www.vagrantup.com/downloads.html"
    end

    # TODO: Terrible using system here, need to look @ thor more to
    # see what we can do to make this sane, or possibly use mxin::command?

    plugins = `vagrant plugin list`.split("\n").map { |i| i.split(" ")[0] }

    %w/vagrant-berkshelf vagrant-omnibus/.each do |plugin|
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
