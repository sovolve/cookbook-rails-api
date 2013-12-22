name "vm_base"
description "VM Base role, sets up users, apt, etc."

run_list(
  "recipe[users::sysadmins]",
  "recipe[sudo]",
  "recipe[apt]",
  "recipe[git]",
  "recipe[build-essential]",
  "recipe[vim]",
  "recipe[curl]",
  "recipe[panomira_api::users]",
  "recipe[panomira_api::apt_setup]",
)
override_attributes(
  authorization: {
    sudo: {
      users: ["ubuntu", "vagrant"],
      passwordless: true,
    }
  }
)
