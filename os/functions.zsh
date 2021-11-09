#!/usr/bin/env bash

# Summary: Search for all Brewfile files and creates the merged file inside ~/.Brefile
function create_brewfiles() {
    merge_files "Brewfile" "$DOTFILES_DIR" "$HOME/.Brewfile"
}
