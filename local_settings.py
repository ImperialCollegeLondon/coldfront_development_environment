"""Settings for Imperial Coldfront deployment.

MUST BE EXTENDED FOR PRODUCTION DEPLOYMENT.
"""

from coldfront.config.env import ENV

# -------------
# AUTH SETTINGS
# -------------

# required for mozilla-django-oidc to work
SESSION_COOKIE_SAMESITE = "Lax"

# if the basic OIDCAuthenticationBackend has been loaded by Coldfront then replace it
# with our customised version.
try:
    AUTHENTICATION_BACKENDS.pop(  # noqa:F821
        AUTHENTICATION_BACKENDS.index(  # noqa:F821
            "mozilla_django_oidc.auth.OIDCAuthenticationBackend"
        )
    )
    AUTHENTICATION_BACKENDS.append(  # noqa:F821
        "imperial_coldfront_plugin.oidc.ICLOIDCAuthenticationBackend"
    )
except ValueError:
    pass

# Enable loading of scopes from environment to be consistent with other OIDC
# settings. Coldfront explicitly enables the others but not this one.
OIDC_RP_SCOPES = ENV.str("OIDC_RP_SCOPES", default="")

# ----------------------
# MISCELLANEOUS SETTINGS
# ----------------------

TIME_ZONE = "Europe/London"

# enable our plugin
PLUGIN_ICL = True
