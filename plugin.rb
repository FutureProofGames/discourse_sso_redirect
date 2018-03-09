# name: discourse_sso_redirect
# about: allows a whitelist for SSO login redirects
# version: 0.1
# authors: Gregory Avery-Weir

after_initialize do
  SessionController.class_eval do
    skip_before_action :check_xhr, only: ['sso', 'sso_login', 'become', 'sso_provider', 'sso_redirect']

    def sso_redirect
      Rails.logger.info "Entering sso_redirect with query string #{request.query_string}"
      redirect = Rack::Utils.parse_query(request.query_string)["return_path"]
      domains = SiteSetting.sso_redirect_domain_whitelist

      # If it's not a relative URL check the host
      if redirect !~ /^\/[^\/]/
        begin
          uri = URI(redirect)
          redirect = "/" unless domains.split('|').include?(uri.host)
        rescue
          redirect = "/"
        end
      end

      Rails.logger.info "About to redirect to #{redirect}"

      redirect_to redirect
    end
  end

  Discourse::Application.routes.append do
    get "session/sso_redirect" => "session#sso_redirect"
  end
end
