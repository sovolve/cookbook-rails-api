name "rails_single_server"
description "Everything required to run the Rails version of the Panomira API, on one server."

run_list(
  "role[memcached]",
  "role[rails_db_master]",
  "role[rails_neo4j_main]",
  "role[rails_neo4j_contacts]",
  "role[rails_webserver]",
)
