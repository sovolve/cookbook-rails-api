name "vagrant_base"
description "Vagrant Base role, includes base role, and adds overrides so that the vagrant user is given sudo."

run_list(
  "recipe[chef-solo-search]", # This MUST be included first if used. Included here as it's assumed that vagrant VM's will be managed using chef-solo.
  "recipe[rvm::vagrant]",
)

override_attributes(
  authorization: {
    sudo: {
      users: ["ubuntu", "vagrant"],
      passwordless: true,
    }
  }
)
