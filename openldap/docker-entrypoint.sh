#!/bin/sh
set -eu

: "${LDAP_ADMIN_PASSWORD:?LDAP_ADMIN_PASSWORD must be set}"

config_file=/etc/ldap/slapd.conf
password_hash="$(slappasswd -s "$LDAP_ADMIN_PASSWORD")"

sed "s@__LDAP_ADMIN_PASSWORD_HASH__@$password_hash@" \
    /etc/ldap/slapd.conf.template > "$config_file"

if [ ! -f /var/lib/ldap/data.mdb ]; then
    slapadd -f "$config_file" -l /bootstrap/01-directory.ldif
    chown -R openldap:openldap /var/lib/ldap
fi

exec slapd -f "$config_file" -h "ldap:/// ldapi:///" -u openldap -g openldap -d 256
