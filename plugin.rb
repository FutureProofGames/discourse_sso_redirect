# name: discourse_sso_redirect
# about: allows a whitelist for SSO login redirects
# version: 0.1
# authors: Gregory Avery-Weir

after_initialize do
  Discourse::Application.routes.append do
    get "session/sso_redirect" => "session#sso_redirect"
  end

  SessionController.class_eval do
    def sso_redirect
      redirect = Rack::Utils.parse_query(request.query_string).return_path
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

      redirect_to redirect