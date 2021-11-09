# Introduction

Dotfiles plugin to setup the devops common software and configuration

## Installation

This plugin need to be installed as part of the main dotfiles and no specific configuration are required to do inside this repository.

## How does it work?

The file's structure is important to handle the configuration, letting you separate each tool's configuration in different folders, allowing you to isolate each configuration.

These folders are what we call **topics**. The structure of each topic is as follows:

- **os/Brewfile**: This list represent all the applications and tools that will be installed with [Homebrew Cask](http://caskroom.io). Everything we have here will be installed as part of the main dotfiles proccess that will read all the Brewfile files and generate a common one inside $HOME/.Brewfile
- **topic/bin/**: Anything inside the bin directory will be added to the $PATH, so you can use it with `dotfiles bin-path`.
- **topic/install.sh**: Any file named `install.sh` will be executed automatically when exeucting `dotfiles install`
- **topic/\<FILENAME | DIRNAME>.symlink**: Any file that ends with `*.symlink` will be added as a symlink to your $HOME.
- **projects/<PROJECT_NAME>**: Here we have all the project's configuration.

## Create a new topic

If you wanted to create a new topic you can create a directory `<TOPIC>` in the root of the dotfiles. Inside you can do some or all of the following:

1. Create an `install.sh` file that contains the installation process (only required for tools that are not present in Homebrew, if they are it's easier to install by updating the `Brewfile`)
2. Create an `alias.zsh` file that contains the commands you want
3. Create a file `functions.zsh` to create utility functions for that topic
4. Create a directory ending with `.symlink` that will symlink all the files inside that directory to your home directory

