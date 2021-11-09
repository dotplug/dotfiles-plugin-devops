#!/bin/zsh

# ============================================================================
# FUNCTIONS
# ============================================================================


# ============================================================================
# MAIN
# ============================================================================

# Uninstall: Instructions taken from https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html#install-plugin-macos

blue "$0 - Uninstalling AWS Session Manager Plugin"
sudo rm -rf /usr/local/sessionmanagerplugin
sudo rm /usr/local/bin/session-manager-plugin

green "$0 - Uninstall of session manager success"
