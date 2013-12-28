default["domain"] = "development.panomira.com"
default["php_api"].tap do |php_api|
  php_api ||= {}
  php_api["path"] = "/data/web/php_api"
  php_api["user"] = "php_api"
  php_api["group"] = "deploy"
  php_api["subdomain"] = "php_api"

  php_api["repo"] = "git@github.com:sovolve/panomira-api.git"

  php_api["database_name"] = "panomira_php_api"
  php_api["database_username"] = "mysql_php_api"
  php_api["database_password"] = "secReTPW@All"

  php_api["neo4j_main"]["port"] = 7474
  php_api["neo4j_contacts"]["port"] = 7475
end