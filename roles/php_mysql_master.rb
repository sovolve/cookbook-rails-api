name "php_mysql_master"
description "Installs a database master to serve the Panomira PHP API."

run_list(
  "recipe[mysql::server]",
  "recipe[panomira_api::php_database]"
)
