#!/bin/sh
set -eu

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 USERNAME" >&2
    exit 1
fi

username="$1"
case "$username" in
    *[!a-z]* | "")
        echo "USERNAME must contain only lowercase letters." >&2
        exit 1
        ;;
esac

base_dn="dc=ic,dc=ac,dc=uk"
user_dn="cn=$username,ou=Users,ou=Imperial College (London),$base_dn"
admin_dn="cn=admin,$base_dn"
password="${LDAP_PASSWORD:-coldfront-local}"

printf '%s\n' \
    "dn: $user_dn" \
    "objectClass: inetOrgPerson" \
    "cn: $username" \
    "sn: Local User" \
    "givenName: Local" \
    "mail: $username@example.test" \
    "uid: $username" \
    | docker compose exec -T ldap ldapadd -x -D "$admin_dn" -w "$password"
