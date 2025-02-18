# Imperial Coldfront Development Environment

This project contains the settings and plugins that comprise the Imperial deployment of
[Coldfront]. This repository aims to provide a unified development experience for
working with Coldfront and the plugins used in the Imperial deployment. This repository
is also used to build the Docker image used for deployment.

Imperial specific settings are contained in `local_settings.py`.

## Plugins

Third-party Coldfront plugins must satisfy certain requirements to work with Coldfront
(see [Coldfront Docs: Creating Plugins]). Meeting these requirements is one of the
reasons this repository is required.

The `coldfront_overrides` directory contains the files that must be patched in Coldfront
to implement support for third party plugins. The patching is carried out in
`Dockerfile` when the image is built to provide a simple development experience.

The following plugins are currently included/configured.

### AUTH_OIDC

This plugin allows logging into Coldfront using Imperial Single Sign On with Open ID
Connect (OIDC). OIDC is a supported authentication mechanism for Coldfront. The
functionality is provided by the [mozilla_django_oidc] package. The `AUTH_OIDC` plugin
is shipped with Coldfront and aims to simplify setup and configuration.

Additional configuration is provided in `local_settings.py` to work with Imperial's
Microsoft Entra tenant. Note that using this plugin with Imperial SSO depends on
[imperial_coldfront_plugin] which provides a customised authentication backend.

Using this plugin is optional (see "Evironment Variables" section below).
If not using OIDC then local authentication is available. 

[mozilla_django_oidc]: https://mozilla-django-oidc.readthedocs.io
[Coldfront Docs: OIDC]: https://coldfront.readthedocs.io/en/latest/config/#openid-connect-auth

### imperial\_coldfront\_plugin

Used to extend Coldfront with Imperial specific behaviours. See [Imperial Coldfront
Plugin: README] for details. It is included as a submodule in this repository for
reproducibility.

[Imperial Coldfront Plugin: README]: https://github.com/ImperialCollegeLondon/imperial_coldfront_plugin
[Coldfront Docs: Creating Plugins]: https://coldfront.readthedocs.io/en/latest/plugin/how_to_create_a_plugin/

## Getting Started

### Cloning

It is recommended to use `git clone --recursive` when obtaining this repository in order
to get the `imperial_coldfront_plugin` submodule. If you don't do a recursive clone you
must manually clone the plugin repository into the submodule directory.

### Environment Variables

Working with this project requires interaction with the Microsoft Graph API. This
requires setting the environment variables `OIDC_RP_CLIENT_ID` and
`OIDC_RP_CLIENT_SECRET`. Values for these can be obtained from the password safe
(direct links - [OIDC_RP_CLIENT_ID] and [OIDC_RP_CLIENT_SECRET]). Ask Chris if you need
access granted to these.

[OIDC_RP_CLIENT_ID]: https://icsecpws.cc.ic.ac.uk:443/GetPassCard.cc?ACCOUNTID=456011&ORGN_NAME=MSP
[OIDC_RP_CLIENT_SECRET]: https://icsecpws.cc.ic.ac.uk:443/GetPassCard.cc?ACCOUNTID=455711&ORGN_NAME=MSP

In order to use the OIDC authentication method and login with your Imperial account you
must also set the environment variable `PLUGIN_AUTH_OIDC=True`.

The docker compose file will pass through the environment variables to the running
containers if they are set in the host environment. Values can also be set in a `.env`
file.

### Running the app

Docker Compose is used to create a reproducible and portable development environment. To
launch Coldfront:

```bash
docker compose up
```

If running Coldfront for the first time (or the database has been recreated) you need to
populate the database:

```bash
docker compose exec app coldfront initial_setup
```

If you've not configured Imperial SSO (see [imperial_coldfront_plugin]) then you'll also
need to create a user account:

```bash
docker compose exec app coldfront createsuperuser
```

You should now be able to access Coldfront at <http://localhost:8000>.

## Development

This repository aims to support interactive testing of plugins and Coldfront
configuration. In order to run the QA tooling and unit tests for a plugin see the
individual repository.

The Docker setup is suitable for use in development. For plugins developed at Imperial,
the Docker setup provides a mount into the running Docker container from the plugin
directory of the host. Unfortunately, the Docker setup does not currently support
auto-reloading when plugins are edited so you have to restart the server (`docker
compose restart app`) for changes to be registered.

[Coldfront]: https://coldfront.readthedocs.io/en/latest/
[imperial_coldfront_plugin]: https://github.com/ImperialCollegeLondon/imperial_coldfront_plugin/tree/main
