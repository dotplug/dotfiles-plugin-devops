#!/usr/bin/env bash

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
