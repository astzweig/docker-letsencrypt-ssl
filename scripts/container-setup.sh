#!/bin/sh

_grab_repo() {
    local DOWNLOAD_URL="${1}";
    local DOWNLOAD_FOLDER="${2}";
    local BRANCH_NAME="${3}";
    if [ -d "${DOWNLOAD_FOLDER}/.git" ]; then
        return 0;
    fi
    git clone "${DOWNLOAD_URL}" "${DOWNLOAD_FOLDER}";
    [ ! -d "${DOWNLOAD_FOLDER}" ] && exit 1;

    if [ "${BRANCH_NAME}" != 'master' ]; then
        cd "${DOWNLOAD_FOLDER}";
        git checkout "${BRANCH_NAME}";
    fi
}

_install_lexicon() {
    local GITHUB_SLUG="${1}";
    local REPO_DIR="${2}";
    local BRANCH="${3}";
    local PROVIDER="${4}";

    _grab_repo "https://github.com/${GITHUB_SLUG}.git" \
               "${REPO_DIR}" \
               "${BRANCH}";

    cd "${REPO_DIR}";
    pip install -e ".[${PROVIDER}]";

    # Check if installation of lexicon worked
    which lexicon > /dev/null;
    [ $? -ne 0 ] && exit 2;
}

_create_cron_file() {
    local DOMAINS="${1}";
    local EMAIL="${2}";
    local HOOK_FILE="${3}";
    local CRON_FILE="${4}";

    cat << EOF > "${CRON_FILE}"
#!/bin/sh
DOMAINS='${DOMAINS}';
oldIFS="\${IFS}" IFS=';'
set -- \${DOMAINS}
IFS="\${oldIFS}";

for domain; do
    certbot certonly --non-interactive \\
        --domains "\${domain}" \\
        --keep-until-expiring \\
        --server https://acme-v02.api.letsencrypt.org/directory \\
        --expand \\
        --agree-tos \\
        -m '${EMAIL}' \\
        --preferred-challenges dns \\
        --manual \\
        --manual-public-ip-logging-ok \\
        --manual-auth-hook "${HOOK_FILE} auth" \\
        --manual-cleanup-hook "${HOOK_FILE} cleanup";
done;
EOF
    [ ! -f "${CRON_FILE}" ] && exit 3;
    chmod u+x "${CRON_FILE}";
}

main () {
    local GITHUB_SLUG="${GITHUB_SLUG:-analogj/lexicon}";
    local BRANCH="${GITHUB_BRANCH:-master}";
    local PROVIDER="${PROVIDER}";
    local EMAIL="${EMAIL}";
    local DOMAINS="${DOMAINS}";
    local REPO_DIR="/lexicon-repo";
    local HOOK_FILE="/usr/local/bin/certbot-hook.sh";
    local CRON_FILE="/etc/periodic/daily/certbot-${PROVIDER}.sh";

    _install_lexicon "${GITHUB_SLUG}" \
                     "${REPO_DIR}" \
                     "${BRANCH}" \
                     "${PROVIDER}";
    _create_cron_file "${DOMAINS}" "${EMAIL}" "${HOOK_FILE}" "${CRON_FILE}";
    /usr/sbin/crond;
    "${CRON_FILE}";  # run hook once at container start-up
    return 0;
}

[ -z "${PROVIDER}" ] && { echo "You need to provide a provider for " \
                               "lexicon-dns via the PROVIDER environment " \
                               "variable.";
                        exit 100; }
[ -z "${EMAIL}" ] && { echo "You need to provide an email address for " \
                            "letsencrypt at which important information " \
                            "will be sent. Use EMAIL environment variable";
                        exit 101; }
[ -z "${DOMAINS}" ] && { echo "You need to provide the DOMAINS environment " \
                              "variable that contains all the domains you " \
                              "want a certificate for.";
                        exit 102; }
[ -z "$(printenv | grep LEXICON)" ] && { echo "You need to provide " \
                              "environment variables with the " \
                              "authentication data for your lexicon " \
                              "provider.";
                        exit 103; }
main "$@";
crond -f;
