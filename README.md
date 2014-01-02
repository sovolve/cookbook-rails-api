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
- Prep and start the VMs: `thor panomira:go`
- Get a coffee. Initial creation of the VMs involves downloading several large files... it's going to take a while.

The PHP VM will be configured at IP address 192.168.33.42, and the PHP version of the Panomira API is configured to run
under the domain name "php_api.development.panomira.com". In order to use this domain name, you will need to add the
following line to your /etc/hosts/ file.

   192.168.33.42 php_api.development.panomira.com 

The Rails VM will be configured at IP address 192.168.33.45, and the Rails version of the Panomira API is configured to
run under the domain name "api.development.panomira.com". In order to use this domain name, you will need to add the 
following line to your /etc/hosts file.

   192.168.33.45 api.development.panomira.com 

# Usage

## Start

To start the VMs at any time: `thor panomira go` 

To start just one vm: thor panomira go <vm_name> (where <vm_name> is one of "rails_api" or "php_api".

## Stop

To shut down the VMs at any time: `thor panomira stop` 

## Update
To update the VMs to the latest settings & codebase: `thor panomira update`

To update just one of the VM's: thor panomira update <vm_name>.

To update the VMs and force a restart as well: `thor panomira update all true`(all can be replaced with a vm name to update / retart only that vm).

## Notes
Chef will install the PHP version of the Panomira API to /data/web/php_api, following a capistrano-like deploy 
process (with a releases folder & the current release symlinked to /current). Chef will automatically deploy the
whatever is the latest commit to the php api repo's "develop" branch. Changes should _not_ be made directly on 
the VM, please make changes and commit / merge them to the develop branch on the PHP api repo and then run 
`thor panomria update` to update the codebase.

Chef will install the Rails version of the Panomira API to /data/web/rails_api, which will be shared with the
host machine. This folder will by default be created "beside" this repo, and the rails code will be checked out
if the folder doesn't exist or the code isn't already checked out. Once the code has been checked out chef will
NOT manage the repo at all, it will simply run whatever code you place there.

# Author

Author:: Alex Willemsma (<alex@sovolve.com>)
