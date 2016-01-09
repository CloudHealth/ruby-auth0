module Auth0
  module Api
    module V2
      # https://auth0.com/docs/api#rules
      module Rules
        # https://auth0.com/docs/api#!#get--api-rules
        def rules
          path = '/api/v2/rules'
          get(path)
        end

        alias_method :get_rules, :rules

        # https://auth0.com/docs/api#!#post--api-rules
        def create_rule(name, script, order = nil, status = true)
          path = '/api/v2/rules'
          request_params = {
            name: name,
            status: status,
            script: script,
            order: order
          }
          post(path, request_params)
        end

        # https://auth0.com/docs/api#!#put--api-rules--rule-name-
        def update_rule(name, script, order = nil, status = true)
          path = "/api/v2/rules/#{name}"
          request_params = {
            status: status,
            script: script,
            order: order
          }
          put(path, request_params)
        end

        # https://auth0.com/docs/api#!#delete--api-rules--rule-name-
        def delete_rule(name)
          path = "/api/v2/rules/#{name}"
          delete(path)
        end
      end
    end
  end
end
