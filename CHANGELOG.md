# 1.0.0

## BREAKING CHANGE

* To compensate for an eager redirect loop check in Discourse's SSO implementation, the external redirect path has changed from `session/sso_redirect` to `session/external_sso_redirect`.
