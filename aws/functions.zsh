#!/usr/bin/env bash

DOTFILES_DIR="$HOME/.dotfiles"

# Access using SSM to an instance.
# Args:
#   * profile: AWS profile to use to authenticate into the account
#   * instance id: to access with SSM
#   * region: where the instance lives. By default eu-west-1
function ssm() {
  if [ "$#" -lt 1 ]; then
    echo "Usage: ssm <profile> <instance-id> [<region>]"
  else
    PROFILE=$1
    INSTANCE_ID=$2
    REGION=${3:-"eu-west-1"}

    blue "[$PROFILE - $REGION] Access into $INSTANCE_ID"
    aws --profile $PROFILE --region $REGION ssm start-session --target $INSTANCE_ID
  fi
}


# List all EC2 instances inside an account
# Args:
#   * profile: AWS profile to use to authenticate into the account
#   * region: where the instance lives. By default eu-west-1
function ssm-instance-list {
  if [ "$#" -lt 1 ]; then
    echo "Usage: ssm-instance-list <profile> <region>"
  else
    PROFILE=$1
    REGION=${2:-"eu-west-1"}

    blue "[$PROFILE - $REGION] List instances"
    output=$(aws --profile $PROFILE \
        --region $REGION \
        ec2 describe-instances \
        --query "Reservations[*].Instances[*].{ID:InstanceId,Type:InstanceType,AZ:Placement.AvailabilityZone,IP:PrivateIpAddress,Name:Tags[?Key=='Name']|[0].Value,State:State.Name}" \
        --output table)

    echo $output
  fi
}

# Forward a local port with an EC2 instance using SSM.
# Args:
#   * profile: AWS profile to use to authenticate into the account
#   * instance id: to access with SSM
#   * remote_port: remote port to forward
#   * local_port: remote port to forward
function ssm-p {
  if [ $# -ne 4 ]
  then
    echo "$FUNCNAME <profile> <instance> <remote_port> <local_port>"
    return 0
  fi
  profile=$1
  instance=$2
  remote_port=$3
  local_port=$4
  aws --region eu-west-1 --profile $profile \
    ssm start-session \
    --target "$instance" \
    --document-name AWS-StartPortForwardingSession \
    --parameters "{\"portNumber\":[\"$remote_port\"],\"localPortNumber\":[\"$local_port\"]}"
}


# Associate an VPN with their hosted zone. It will:
#   1. Create the association authorization.
#   2. Associate the VPC with the hosted zone.
#   3. Delete the association authorization.
# Args:
#   * account profile that created the hosted zone: The AWS profile where the hosted zone to share is created.
#   * hosted zone to associate: The AWS hosted zone ID that you want to associate
#   * account profile that created the VPC: The AWS profile where the VPC to share is created.
#   * vpc id: The VPC ID that want to have the association.
function associate-vpc-with-hosted-zone() {
  # Process based on https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/hosted-zone-private-associate-vpcs-different-accounts.html
  local ACCOUNT_PROFILE_THAT_CREATED_HOSTED_ZONE=$1
  local HOSTED_ZONE_TO_ASSOCIATE=$2

  local ACCOUNT_PROFILE_THAT_CREATED_VPC=$3
  local VPC_ID_TO_ASSOCIATE=$4
  local VPC_REGION=$5

  if [[ $# -ne 5 ]]; then
    echo "Usage associate-vpc-with-hosted-zone <ACCOUNT_PROFILE_THAT_CREATED_HOSTED_ZONE> <HOSTED_ZONE_TO_ASSOCIATE> <ACCOUNT_PROFILE_THAT_CREATED_VPC> <VPC_ID_TO_ASSOCIATE> <VPC_REGION>"
    return 0
  fi

  # Step 1 - create association authorization
  echo aws --profile $ACCOUNT_PROFILE_THAT_CREATED_HOSTED_ZONE --region eu-west-1 route53 create-vpc-association-authorization --hosted-zone-id $HOSTED_ZONE_TO_ASSOCIATE --vpc VPCRegion=$VPC_REGION,VPCId=$VPC_ID_TO_ASSOCIATE
  # Step 2 - associate vpc with hosted zone
  echo aws --profile $ACCOUNT_PROFILE_THAT_CREATED_VPC --region eu-west-1 route53 associate-vpc-with-hosted-zone --hosted-zone-id $HOSTED_ZONE_TO_ASSOCIATE --vpc VPCRegion=$VPC_REGION,VPCId=$VPC_ID_TO_ASSOCIATE
  # Step 3 - delete association authorization
  echo aws --profile $ACCOUNT_PROFILE_THAT_CREATED_HOSTED_ZONE --region eu-west-1 route53 delete-vpc-association-authorization --hosted-zone-id $HOSTED_ZONE_TO_ASSOCIATE --vpc VPCRegion=$VPC_REGION,VPCId=$VPC_ID_TO_ASSOCIATE
}


# Disassociate an VPN with their hosted zone.
# Args:
#   * account profile that created the hosted zone: The AWS profile where the hosted zone to share is created.
#   * hosted zone to associate: The AWS hosted zone ID that you want to associate
#   * account profile that created the VPC: The AWS profile where the VPC to share is created.
#   * vpc id: The VPC ID that want to have the association.
#   * vpc region: The VPC ID that want to have the association.
function disassociate-vpc-from-hosted-zone() {
  # Process based on https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/hosted-zone-private-associate-vpcs-different-accounts.html
  local ACCOUNT_PROFILE_THAT_CREATED_HOSTED_ZONE=$1
  local HOSTED_ZONE_TO_ASSOCIATE=$2

  local ACCOUNT_PROFILE_THAT_CREATED_VPC=$3
  local VPC_ID_TO_ASSOCIATE=$4
  local VPC_REGION=$5

  if [[ $# -ne 5 ]]; then
    echo "Usage disassociate-vpc-from-hosted-zone <ACCOUNT_PROFILE_THAT_CREATED_HOSTED_ZONE> <HOSTED_ZONE_TO_ASSOCIATE> <ACCOUNT_PROFILE_THAT_CREATED_VPC> <VPC_ID_TO_ASSOCIATE> <VPC_REGION>"
    return 0
  fi

  # Step 1 - Disassociate vpc from hosted zone
  echo aws --profile $ACCOUNT_PROFILE_THAT_CREATED_HOSTED_ZONE --region eu-west-1 route53 disassociate-vpc-from-hosted-zone --hosted-zone-id $HOSTED_ZONE_TO_ASSOCIATE --vpc VPCRegion=$VPC_REGION,VPCId=$VPC_ID_TO_ASSOCIATE
}


# Summary: Search for all SOURCE_FILE inside SOURCE_FOLDER and generates the DESTINATION_FILE
function merge_files() {
    local SOURCE_FILE=$1
    local SOURCE_FOLDER=$2
    local DESTINATION_FILE=$3

    blue "Cleanup $DESTINATION_FILE"
    rm $DESTINATION_FILE

    blue "Search for $SOURCE_FILE inside $SOURCE_FOLDER"
    cat $(find -H "$SOURCE_FOLDER" -type f -name "$SOURCE_FILE") >> $DESTINATION_FILE

    green "Generated $DESTINATION_FILE"
}

# Get all aws-credentials file to generate the credentials file combined
function create_aws_credentials() {
    mkdir -p "$HOME/.aws"
    merge_files "aws-credentials" "$DOTFILES_DIR" "$HOME/.aws/credentials"
    merge_files "aws-mfa-credentials" "$DOTFILES_DIR" "$HOME/.aws/mfa_credentials"
}

# Get all aws-config file to generate the config file combined
function create_aws_configuration() {
    mkdir -p "$HOME/.aws"
    merge_files "aws-config" "$DOTFILES_DIR" "$HOME/.aws/config"
}

