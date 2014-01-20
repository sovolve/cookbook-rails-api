name "development_rails_webserver"
description "Installs a webserver to serve the Panomira Rails API in 'development mode' (running off a shared folder)."

run_list(
  "role[base]",
  "recipe[panomira_rails_api::hosts]",
  "recipe[panomira_rails_api::shared_application]",
)
