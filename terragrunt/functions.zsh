#!/bin/bash

# Get the stding and filter using the $PATTERN_TO_SEARCH and create a terragrunt state mv command with the new name of the state resource.
function tg_mv_state() {
  PATTERN_TO_SEARCH=$1
  NEW_PATTERN=$2

  FILTERED_STATES=$(grep $PATTERN_TO_SEARCH)

  if [[ $# == 2 ]]; then
    while IFS='$\n' read -r ORIGINAL; do
      NEW_STATE_NAME=$(echo $ORIGINAL | sed -e "s/$PATTERN_TO_SEARCH/$NEW_PATTERN/g")
      echo terragrunt state mv $ORIGINAL $NEW_STATE_NAME
      # NOTE: Uncomment this to perform the state move
      # terragrunt state mv $ORIGINAL $NEW_STATE_NAME
    done < <(echo $FILTERED_STATES)
  else
    echo 'terragrunt state list| tg_mv_state "current state name" "new state name"'
    exit 1
  fi
}

# Function to refacor all batches state secrets
# execute the command in a directory. by default the base dir is the current dir
# function refactor_all_batch_states_secrets() {
#   BATCHES=('accounts-fiscal-report-batch-ob' 'accounts-interest-manager-batch-ob' 'accounts-monthly-interest-batch-ob' 'accounts-monthly-statement-batch-ob' 'accounts-sync-batch-ob' 'accounts-yearly-fees-batch-ob' 'cards-embossing-batch-processor-ob' 'sandbox-batch-ob' 'transfers-batches-ob')
# 
#   for B_NAME in $BATCHES; do
#     cd $B_NAME
#     terragrunt state list| tg_mv_state "aws_secretsmanager_secret_version.secret-kafka" "aws_secretsmanager_secret_version.kafka"
#     terragrunt state list| tg_mv_state "aws_secretsmanager_secret_version.secret-batch-tasks-ob" "aws_secretsmanager_secret_version.batch-tasks-database"
#     terragrunt state list| tg_mv_state "aws_secretsmanager_secret_version.secret" "aws_secretsmanager_secret_version.random"
#     terragrunt plan
#     cd -
#   done
# }
