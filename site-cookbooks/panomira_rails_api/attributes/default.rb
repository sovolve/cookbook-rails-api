default["domain"] = "development.panomira.com"
default["rails_api"].tap do |rails_api|
  rails_api ||= {}
  rails_api["path"] = "/data/web/rails_api"
  rails_api["user"] = "rails_api"
  rails_api["group"] = "deploy"
  rails_api["subdomain"] = "api"

  rails_api["repo"] = "git@github.com:sovolve/panomira-api-ror.git"

  rails_api["database_name"] = "panomira_rails_api"
  rails_api["database_username"] = "mysql_rails_api"
  rails_api["database_password"] = "anotherP@ssword"

  rails_api["neo4j_main"]["port"] = 7476
  rails_api["neo4j_contacts"]["port"] = 7477
end
