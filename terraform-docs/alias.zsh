#!/bin/bash

alias tf-docs="terraform-docs markdown table . -c .terraform-docs.yml"
alias tfpc="tf-docs > README.md && terraform fmt"
