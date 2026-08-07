# Local OpenLDAP Service

This directory defines the local LDAP service used by the development Compose stack.
It emulates only the Active Directory schema surface used by
`imperial_coldfront_plugin`; it does not contain real directory data.

## Components

| Path | Purpose |
| --- | --- |
| `Dockerfile` | Builds the local image from Debian, installing OpenLDAP and LDAP command-line tools. |
| `docker-entrypoint.sh` | Creates the LDAP database from the fixture LDIF on first start of an empty volume, then starts `slapd`. |
| `slapd.conf.template` | Configures the base DN, administrator DN, MDB backend, access rules, and loaded schemas. |
| `schema/imperial-ad.schema` | Defines the small number of AD-compatible attributes and the `group` object class required by the plugin. |
| `bootstrap/01-directory.ldif` | Creates the directory tree, fictional users, and the shared `hx2dev-users` group. |

The database is stored in the Compose `ldap` volume. Bootstrap data is imported only
when that volume has no `data.mdb` file.

## Common changes

### Add a local user

Use the helper from the repository root:

```bash
sh scripts/add-local-ldap-user.sh example.user
```

It creates a fictional `inetOrgPerson` entry with the supplied username. The username
must use lowercase letters, digits, dots, underscores, or hyphens.

### Change seeded users or groups

Edit `bootstrap/01-directory.ldif`. The changes apply only when a new LDAP volume is
initialized, so reset the development volumes afterwards:

```bash
docker compose down --volumes
docker compose up
```

This also removes the local Coldfront SQLite database.

Allocation groups are normally created by the plugin. Keep `hx2dev-users` in the
bootstrap file because it is a shared group that the plugin expects to exist.

### Change the LDAP schema

Add or amend definitions in `schema/imperial-ad.schema`, then rebuild the service and
reset the LDAP volume as above. Keep the schema limited to attributes and object
classes used by the plugin; this is a local compatibility layer, not a full AD schema.

### Change server configuration

Edit `slapd.conf.template` to change the base DN, access policy, schemas, or database
settings. The entrypoint derives the administrator password hash at container startup
from `LDAP_ADMIN_PASSWORD`, which Compose sets to the development-only local value.
