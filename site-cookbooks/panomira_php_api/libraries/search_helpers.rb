class Chef
  class Recipe
    def node_by_role(role, environment = nil)
      environment ||= node.chef_environment

      if role
        matched_node = begin
          if node['roles'].include? role
            node
          else
            search(:node, "role:#{role} AND chef_environment:#{environment}").first
          end
        end
        raise "No node found with role #{role}!" unless matched_node
        matched_node
      end
    end

    def host_from_node(matched_node = nil)
      if matched_node
        host = if matched_node.attribute?('cloud')
          matched_node['cloud']['local_ipv4']
        else
          matched_node['ipaddress']
        end
        (host && host == node.ipaddress) ? 'localhost' : host
      end
    end
  end
end
