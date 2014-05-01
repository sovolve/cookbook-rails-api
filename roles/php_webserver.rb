name "php_webserver"
description "Installs a webserver to serve the Panomira PHP API."

run_list(
  "role[base]",
  # note: this recipe also goes first for "php_single_server" role - do not remove either one
  "recipe[panomira_php_api::apache2_php_upgrade]",
  "recipe[panomira_php_api::application]",
)

default_attributes(
  "apache" => {
    "listen_ports" => ["80", "443"]
  }
)
