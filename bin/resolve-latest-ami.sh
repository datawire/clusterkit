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

namespace="dwc"
role="foundation"

for i in "$@"; do
  case "$i" in
    -n=*|--namespace=*)
      namespace="${i#*=}"
    shift
    ;;
    --debug)
      debug_mode=true
    shift
    ;;
    -r=*|--role=*)
      role="${i#*=}"
    shift
    ;;
    *)
      echo "unknown option (option: $i)"
      exit 1
    ;;
  esac
done

if [ "$debug_mode" == true ]; then
  echo "--> Querying for latest AMI (role: ${namespace}:images:${role})"
fi

aws ec2 describe-images \
  --owner self \
  --filters Name=tag:Role,Values="${namespace}:images:${role}" \
  --query 'Images[*].[ImageId,CreationDate]' \
  --output text | sort -r -k2 | head -n1 | cut -f1