# Panomira Rails API Cookbook

# Requirements

- Install [Ruby](https://www.ruby-lang.org/en/downloads/) and [Bundler](http://bundler.io/) (most Mac / Linux boxes probably already have Ruby).
- Install [Vagrant](http://www.vagrantup.com/downloads.html)
- Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads) or [VMWare](http://www.vmware.com/products/fusion/)
- Clone this repo `git clone git@github.com:sovolve/cookbook-rails-api.git`
- You will need the data_bag_key file in order to use this repository. Please talk to Gabe or Alex W to get it. Once
you've gotten this file, it needs to be placed in the root directory (alongside this README) and _must_ be named data_bag_key (with no extension).
- Open a terminal to the directory where you cloned this repository.
- Run bundle install: `bundle install`
- Prep and start the vm: `thor panomira:go`
- Get a coffee. Initial creation of the VM involves downloading several large files... it's going to take a while.

The VM will be configured at IP address 192.168.33.42, and the PHP version of the Panomira API is configured to run
under the domain name "php_api.development.panomira.com". In order to use this domain name, you will need to add the
following line to your /etc/hosts/ file.

   192.168.33.42 php_api.development.panomira.com 

# Usage

## Start

To start the VM at any time: `thor panomira:go` 

## Stop

To shut down the VM at any time: `thor panomira:stop` 

## Update
To update the VM to the latest settings & codebase: `thor panomira:update`

To update the VM and force a restart as well: `thor panomira:update true`

## Notes
Chef will install the PHP version of the Panomira API to /data/web/php_api, following a capistrano-like deploy 
process (with a releases folder & the current release symlinked to /current). Chef will automatically deploy the
whatever is the latest commit to the php api repo's "develop" branch. Changes should _not_ be made directly on 
the VM, please make changes and commit / merge them to the develop branch on the PHP api repo and then run 
`thor panomria:update` to update the codebase.

# Author

Author:: Alex Willemsma (<alex@sovolve.com>)
