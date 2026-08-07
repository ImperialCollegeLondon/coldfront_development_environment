FROM debian:bookworm-slim

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends \
        ldap-utils \
        slapd \
    && rm -rf /var/lib/apt/lists/* /etc/ldap/slapd.d /var/lib/ldap/*

COPY schema/imperial-ad.schema /etc/ldap/schema/imperial-ad.schema
COPY bootstrap/01-directory.ldif /bootstrap/01-directory.ldif
COPY slapd.conf.template /etc/ldap/slapd.conf.template
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN chmod 755 /usr/local/bin/docker-entrypoint.sh

VOLUME ["/var/lib/ldap"]

EXPOSE 389

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
