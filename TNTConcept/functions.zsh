#!/usr/bin/env bash


# Create the TNT configuration file for each repository.
function repositories_tnt() {
    local BASE_DIR=$1
    local ORGANIZATION=$2
    local PROJECT=$3
    local ROLE=$4

    # 1. Check if directory listed have ".git directory
    # 2. Print the repository name
    # 3. Execute the TNTGitHook credentials setup
    # 4. Execute the TNTGitHook setup with the arguments
    # find $BASE_DIR -type d -name ".git" -maxdepth 3 -exec blue "Setup TNTGitHook: {}" \; -execdir python3 -m TNTGitHook --set-credentials  \; -execdir python3 -m TNTGitHook --setup --organization $ORGANIZATION --project $PROJECT --role $ROLE \;
    find $BASE_DIR -type d -name ".git" -maxdepth 3 -exec blue "Setup TNTGitHook: {}" \; -execdir python3 -m TNTGitHook --setup --organization $ORGANIZATION --project $PROJECT --role $ROLE \;

}
