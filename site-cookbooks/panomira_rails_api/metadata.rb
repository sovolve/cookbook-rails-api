name             'panomira_rails_api'
maintainer       'Alex Willemsma'
maintainer_email 'alex@sovolve.com'
license          'All rights reserved'
description      'Installs/Configures Panomira Rails API'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends "ssh"
depends "application"
depends "application_ruby"
depends "database"
depends "neo4j-multi-server"
depends "rvm"
depends "nginx"
