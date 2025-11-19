# Zsh helpers for common AWS CLI tasks. Provides aliases and functions that call
# the aws CLI and format output with jq and column. Requires: aws, jq, column.

# Enable aws CLI tab completion by using the aws_completer. If zsh doesn't
# support bash-style completions, you may need:
#   autoload -Uz bashcompinit; bashcompinit
complete -C aws_completer aws

# List EC2 instances in a human-readable table:
# - Calls `aws ec2 describe-instances`
# - Uses jq to extract columns: Name, state, instance id, AZ, private IP,
#   public IP (or NULL), launch time, and instance type
# - Converts to CSV, replaces empty values with "NULL", and formats into a
#   aligned table with column separators.
alias adesci="aws ec2 describe-instances | jq -r '([\"name\",\"state\",\"id\",\"az\",\"priv_ip\",\"pub_ip\",\"ca\",\"type\"] | (., map(length*\"-\"))), (.Reservations[].Instances[] | [(.Tags // {} | from_entries | .Name), .State.Name, .InstanceId, .Placement.AvailabilityZone, .PrivateIpAddress, .PublicIpAddress // \"NULL\", .LaunchTime, .InstanceType]) | @csv' | sed -e 's/,,/,\"NULL\",/g' -e 's/,/  |  /g' -e 's/^/|  /g' -e 's/$/  |/g' -e 's/\"//g' | column -t"

# Lookup recent CloudTrail events for a specific resource name:
# - Calls `aws cloudtrail lookup-events` filtering by ResourceName
# - Limits results to the most recent 3 events and pretty-prints with jq
# Usage: actrail <resource-name>
actrail() {
    aws cloudtrail lookup-events --max-results 3 --lookup-attributes AttributeKey=ResourceName,AttributeValue="$1" | jq
}

# List Auto Scaling lifecycle hooks, or complete a lifecycle action for an instance:
# - No arguments: lists all Auto Scaling Groups and their lifecycle hook names
# - With <instance> <hook> [asg-name]: completes the lifecycle action for the
#   given instance and hook (uses CONTINUE). If the ASG name is not provided,
#   it attempts to read the 'aws:autoscaling:groupName' tag from the instance.
# Usage:
#   alifecycle                # list hooks
#   alifecycle <instance> <hook> [asg-name]
alifecycle() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        asgs=($(aws autoscaling describe-auto-scaling-groups --query 'AutoScalingGroups[].AutoScalingGroupName' --output text))
        for asg in "${asgs[@]}"; do
            echo "Auto Scaling Group: $asg"
            aws autoscaling describe-lifecycle-hooks --auto-scaling-group-name "$asg" --query 'LifecycleHooks[].LifecycleHookName' --output text
        done
    else
        local instance_id="$1"
        local hook_name="$2"
        local asg_name="${3:-}"
        if [ -z "$asg_name" ]; then
            asg_name=$(aws ec2 describe-instances --instance-ids "$instance_id" \
                --query 'Reservations[].Instances[].Tags[?Key==`aws:autoscaling:groupName`].Value' --output text)
            if [ -z "$asg_name" ]; then
                echo "Auto Scaling Group name not provided and could not be determined for instance $instance_id."
                return 1
            fi
        fi
        aws autoscaling complete-lifecycle-action \
            --lifecycle-action-result CONTINUE \
            --instance-id "$instance_id" \
            --lifecycle-hook-name "$hook_name" \
            --auto-scaling-group-name "$asg_name"
    fi
}

# Decode an STS encoded authorization message and pretty-print the resulting JSON:
# - Calls `aws sts decode-authorization-message` and pipes the DecodedMessage to jq
# Usage: adecode <encoded-message>
adecode() {
    aws sts decode-authorization-message --encoded-message "$1" --query DecodedMessage --output text | jq '.'
}
