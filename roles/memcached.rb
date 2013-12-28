name "php_memcached"
description "Installs a mecached server."

run_list(
  "role[base]",
  "recipe[memcached]",
)
