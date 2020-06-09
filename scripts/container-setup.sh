#!/bin/sh

_create_cron_file() {
    local DOMAINS="${1}";
    local EMAIL="${2}";
    local HOOK_FILE="${3}";
    local CRON_FILE="${4}";

    cat << EOF > "${CRON_FILE}"
#!/bin/sh
oldIFS="\${IFS}" IFS=';'
set -- \${DOMAINS}
IFS="\${oldIFS}";

for domain; do
    EXTARG=""
    EXTARG=\$(python /usr/local/bin/check_domains.py "\${domain}")
    if [ -z "\${STAGING}" ]; then
        SERVER_URL=https://acme-v02.api.letsencrypt.org/directory
    else
        SERVER_URL=https://acme-staging-v02.api.letsencrypt.org/directory
    fi
    certbot certonly \${EXTARG} \\
        --domains "\${domain}" \\
        --keep-until-expiring \\
        --server https://acme-v02.api.letsencrypt.org/directory \\
        --expand \\
        --agree-tos \\
        -m '\${EMAIL}' \\
        --preferred-challenges dns \\
        --manual \\
        --manual-public-ip-logging-ok \\
        --manual-auth-hook ${HOOK_FILE};
done;
EOF
    [ ! -f "${CRON_FILE}" ] && exit 3;
    chmod u+x "${CRON_FILE}";
}

main () {
    local EMAIL="${EMAIL}";
    local DOMAINS="${DOMAINS}";
    local HOOK_FILE="/usr/local/bin/hook.sh";
    local CRON_FILE="/etc/periodic/daily/certbot.sh";

    _create_cron_file "${DOMAINS}" "${EMAIL}" "${HOOK_FILE}" "${CRON_FILE}";
    /usr/sbin/crond -f;
    return 0;
}

[ -z "${EMAIL}" ] && { echo "You need to provide an email address for " \
                            "letsencrypt at which important information " \
                            "will be sent. Use EMAIL environment variable";
                        exit 101; }
[ -z "${DOMAINS}" ] && { echo "You need to provide the DOMAINS environment " \
                              "variable that contains all the domains you " \
                              "want a certificate for.";
                        exit 102; }
main "$@";
crond -f;
