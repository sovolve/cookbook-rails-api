name "rails_neo4j_main"
description "Installs the 'main' neo4j instance for Rails API."

run_list(
  "role[base]",
  "recipe[panomira_rails_api::neo4j_main]",
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
