name "base"
description "Base role for all created machines."

run_list(
  "recipe[users::sysadmins]",
  "recipe[sudo]",
  "recipe[apt]",
  "recipe[git]",
  "recipe[homesick::data_bag]",
  "recipe[build-essential]",
  "recipe[vim]",
  "recipe[curl]",
  "recipe[panomira_php_api::users]",
  "recipe[panomira_php_api::apt_setup]",
)
