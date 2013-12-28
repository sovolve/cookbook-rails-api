name "php_single_server"
description "Everything required to run the PHP version of the Panomira API, on one server."

run_list(
  "role[memcached]",
  "role[php_mysql_master]",
  "role[php_neo4j_main]",
  "role[php_neo4j_contacts]",
  "role[php_webserver]",
)
