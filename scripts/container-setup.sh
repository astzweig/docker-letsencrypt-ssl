#!/bin/sh

main () {
    local GITHUB_SLUG="${GITHUB_SLUG:-analogj/lexicon}";
    local BRANCH="${GITHUB_BRANCH:-master}";
    local PROVIDER="${PROVIDER}";
    local REPO_DIR="/lexicon-repo";
    return 0;
}

[ -z "${PROVIDER}" ] && { echo "You need to provide a provider for " \
                               "lexicon-dns via the PROVIDER environment " \
                               "variable.";
                        exit 100; }
main "$@";
