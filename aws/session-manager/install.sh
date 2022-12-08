#!/usr/bin/env bash


# ============================================================================
# FUNCTIONS
# ============================================================================


# ============================================================================
# MAIN
# ============================================================================

blue "$0 - Check if AWS Session Manager plugin is installed"

/usr/local/bin/session-manager-plugin
IS_INSTALLED=$?

if [[ $IS_INSTALLED == 0 ]]; then
    green "$0 - AWS Session Manager Plugin already installed"
    exit 0
fi

# Start download: Instructions from https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html#install-plugin-macos
blue "$0 - Not installed. Start download in ~/Download"

cd ~/Downloads
curl 'https://s3.amazonaws.com/session-manager-downloads/plugin/latest/mac/sessionmanager-bundle.zip' -o 'sessionmanager-bundle.zip'
unzip sessionmanager-bundle.zip
sudo ./sessionmanager-bundle/install -i /usr/local/sessionmanagerplugin -b /usr/local/bin/session-manager-plugin
if [[ $? != 0 ]];then
  red "Plugin is not installed, take a look at the installation process"
fi

blue "$0 - Delete downloaded zip"
rm ~/Downloads/sessionmanager-bundle.zip

green "$0 - AWS session manager installed"
