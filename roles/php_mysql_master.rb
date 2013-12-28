name "php_mysql_master"
description "Installs a database master to serve the Panomira PHP API."

run_list(
  "role[base]",
  "recipe[mysql::server]",
  "recipe[panomira_php_api::database_setup]"
)

override_attributes(
  mysql: {
    remove_anonymous_users: true,
    remove_test_database: true,
  }
)

