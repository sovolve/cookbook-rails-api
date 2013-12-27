name "php_webserver"
description "Installs a webserver to serve the Panomira PHP API."

run_list(
  "recipe[apache2]",
  "recipe[panomira_php_api::php_application]",
)

default_attributes(
  "apache" => {
    "listen_ports" => ["80", "443"]
  }
)
