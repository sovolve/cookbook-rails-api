name "php_neo4j_main"
description "Installs the 'main' neo4j instance for PHP API."

run_list(
  "recipe[neo4j-multi-server::tarball",
)

default_attributes(
  {
    :neo4j => {
      :server => {
        :instance_name => 'main',
        :port => 7474,
      }
    }
  }
)
