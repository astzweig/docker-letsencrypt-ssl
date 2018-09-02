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

main () {
    local GITHUB_SLUG="${GITHUB_SLUG:-analogj/lexicon}";
    local BRANCH="${GITHUB_BRANCH:-master}";
    local PROVIDER="${PROVIDER}";
    local REPO_DIR="/lexicon-repo";

    _grab_repo "https://github.com/${GITHUB_SLUG}.git" \
               "${REPO_DIR}" \
               "${BRANCH}";
    return 0;
}

[ -z "${PROVIDER}" ] && { echo "You need to provide a provider for " \
                               "lexicon-dns via the PROVIDER environment " \
                               "variable.";
                        exit 100; }
main "$@";
