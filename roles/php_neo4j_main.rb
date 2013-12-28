name "php_neo4j_main"
description "Installs the 'main' neo4j instance for PHP API."

run_list(
  "role[base]",
  "recipe[panomira_php_api::neo4j_main]",
)

override_attributes(
  neo4j: {
    server: {
      https: { 
        enabled: false,
      },
    },
  },
)
