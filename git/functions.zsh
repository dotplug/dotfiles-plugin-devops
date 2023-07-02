#!/usr/bin/env bash

# This function create a repository and receive following parameters:
# BASE_DIR: Directory where repository will be created
# PROJECT_DIR: Name of the project where the repository belongs
# REPO_DIR: Name of the directory to perform the repository
# REPO_URL: Repository url to perform the git clone
function create_repository() {
    local BASE_DIR=$1
    local PROJECT_DIR=$2
    local REPO_DIR=$3
    local REPO_URL=$4

    local REPO_PATH="$BASE_DIR/$PROJECT_DIR/$REPO_DIR"

    if [[ ! -d $REPO_PATH ]]; then
        blue "Creating repository in: $REPO_PATH"
        git clone $REPO_URL $REPO_PATH -v
    fi
}

function repositories_status() {
    local BASE_DIR=$1

    # 1. Check if directory listed have ".git directory
    # 2. Print the repository name
    # 4. Execute git status command (coloured)
    find $BASE_DIR -type d -name ".git" -maxdepth 3 -exec blue "Repository: {}" \; -execdir git status \;
}

function repositories_update() {
    local BASE_DIR=$1

    # 1. Check if directory listed have ".git directory
    # 2. Print the repository name
    # 4. Execute git pull command (coloured)
    find $BASE_DIR -type d -name ".git" -maxdepth 3 -exec blue "Repository: {}" \; -execdir git pull \;
}

function repositories_checkout() {
    local BASE_DIR=$1
    local BRANCH_TO_CHECKOUT=$2

    # 1. Check if directory listed have ".git directory
    # 2. Print the repository name
    # 4. Execute git checkout master command (coloured)
    find $BASE_DIR -type d -name ".git" -maxdepth 3 -exec blue "Repository: {}" \; -execdir git checkout $BRANCH_TO_CHECKOUT \;
}

# Get the .editconfig inside dotfiles and copy to the current folder
function repository_setup() {
  blue "Creating .editorconfig file"
  cp $HOME/.dotfiles/plugins/dotfiles-plugin-personal/.editorconfig .
}


# Prune the branches in sync with the remote (but master, development, integration preproduction and production) and delete trash branches.
# If the branch is not in sync it won't be deleted
function clean_branches() {
  blue "Cleaning unused branches"
  git branch --format '%(refname:short)' | grep -v -E '^(master|main|development|integration|production)$' | xargs git branch -d && git fetch --prune
}

# Create an empty commit with default message
# usage: clean_branches PLATEU-827 [commit message for something]
function git_empty_commit() {
  $TASK=$1
  $MESSAGE=${2:-"dummy commit"}
  git commit --allow-empty -m "chore($TASK): $MESSAGE"
}
