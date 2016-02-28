#!/usr/bin/env bash

# Copyright 2015, 2016 Datawire. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e
set -u
set -o pipefail

debug_mode="false"

cluster_name=$(terraform output cluster_autoscaling_group_name)
force=false

for i in "$@"; do
  case "$i" in
    -a=*|--all=*)
      namespace="${i#*=}"
    shift
    ;;
    --debug)
      debug_mode=true
    shift
    ;;
    -f|--force)
      force=true
    shift
    ;;
    *)
      echo "unknown option (option: $i)"
      exit 1
    ;;
  esac
done

echo "--> Setting all instances in the cluster to unhealthy (cluster: ${cluster_name})"

instances=$(\
  aws autoscaling describe-auto-scaling-groups \
  --auto-scaling-group-name $(terraform output cluster_autoscaling_group_name) \
  --query 'AutoScalingGroups[*].Instances[*].[InstanceId]' \
  --output=text \
)

while read -r instance_id; do
    if [ "${force}" == "true" ]; then
      echo "--> Giving the sickness (instance: ${instance_id}, forced)"
      aws autoscaling set-instance-health \
        --instance-id ${instance_id} \
        --health-status Unhealthy \
        --no-should-respect-grace-period
    else
      echo "--> Giving the sickness (instance: ${instance_id})"
      aws autoscaling set-instance-health \
        --instance-id ${instance_id} \
        --health-status Unhealthy
    fi
done <<< "$instances"

echo "--> Done!"