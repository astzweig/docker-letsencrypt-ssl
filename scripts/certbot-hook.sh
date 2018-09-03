#!/bin/sh
PROVIDER_DNS_DELAY="${PROVIDER_DNS_DELAY:-30}";

auth () {
    lexicon --delegated "\${CERTBOT_DOMAIN}" \
        "${PROVIDER}" create "${CERTBOT_DOMAIN}" TXT \
        --name "_acme-challenge.${CERTBOT_DOMAIN}" \
        --content "${CERTBOT_VALIDATION}" \
        --ttl 360;

    sleep "${PROVIDER_DNS_DELAY}";
}

cleanup () {
    lexicon --delegated "${CERTBOT_DOMAIN}" \
        "${PROVIDER}" delete "${CERTBOT_DOMAIN}" TXT \
        --name "_acme-challenge.${CERTBOT_DOMAIN}" \
        --content "${CERTBOT_VALIDATION}";

    sleep "${PROVIDER_DNS_DELAY}";
}

HANDLER="${1}"; shift;
type -t ${HANDLER} > /dev/null;
[ $? -eq 0 ] && "${HANDLER}" "${@}";