name "php_neo4j_contacts"
description "Installs the 'contacts' neo4j instance for PHP API."

run_list(
  "role[base]",
  "recipe[panomira_php_api::neo4j_contacts]",
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
