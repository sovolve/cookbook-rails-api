name "rails_webserver"
description "Installs a webserver to serve the Panomira Rails API."

run_list(
  "recipe[panomira_rails_api::application]",
)
