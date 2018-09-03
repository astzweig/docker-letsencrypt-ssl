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

main () {
    local GITHUB_SLUG="${GITHUB_SLUG:-analogj/lexicon}";
    local BRANCH="${GITHUB_BRANCH:-master}";
    local PROVIDER="${PROVIDER}";
    local REPO_DIR="/lexicon-repo";

    _install_lexicon "${GITHUB_SLUG}" \
                     "${REPO_DIR}" \
                     "${BRANCH}" \
                     "${PROVIDER}";
    return 0;
}

[ -z "${PROVIDER}" ] && { echo "You need to provide a provider for " \
                               "lexicon-dns via the PROVIDER environment " \
                               "variable.";
                        exit 100; }
[ -z "$(printenv | grep LEXICON)" ] && { echo "You need to provide " \
                              "environment variables with the " \
                              "authentication data for your lexicon " \
                              "provider.";
                        exit 101; }
main "$@";
