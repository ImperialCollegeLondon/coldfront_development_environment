SESSION_COOKIE_SAMESITE = 'Lax'  # required for oidc to work

try:
    AUTHENTICATION_BACKENDS.pop(AUTHENTICATION_BACKENDS.index("mozilla_django_oidc.auth.OIDCAuthenticationBackend"))
    AUTHENTICATION_BACKENDS.append("imperial_coldfront_plugin.ICLOIDCAuthenticationBackend")
except ValueError:
    pass

TIME_ZONE="Europe/London"

RESEARCH_OUTPUT_ENABLE=False
GRANT_ENABLE=False
PUBLICATION_ENABLE=False

# OIDC_RP_SCOPES="openid email"
OIDC_RP_SCOPES="openid email profile"
PLUGIN_ICL = True
