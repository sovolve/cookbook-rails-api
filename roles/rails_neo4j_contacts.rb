name "rails_neo4j_contacts"
description "Installs the 'contacts' neo4j instance for Rails API."

run_list(
  "role[base]",
  "recipe[panomira_rails_api::neo4j_contacts]",
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
