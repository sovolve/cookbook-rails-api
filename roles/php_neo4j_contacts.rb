name "php_neo4j_contacts"
description "Installs the 'contacts' neo4j instance for PHP API."

run_list(
  "recipe[panomira_php_api::php_neo4j_contacts]",
)
