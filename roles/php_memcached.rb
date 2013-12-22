name "php_memcached"
description "Installs a mecached server, configured for the php api."

run_list(
  "recipe[memcached]",
)
