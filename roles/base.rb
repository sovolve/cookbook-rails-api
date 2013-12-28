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
)

override_attributes(
  users: ['alex', 'mike', 'jason'], # Used by homesick to determine which users to setup homesick for.
)
