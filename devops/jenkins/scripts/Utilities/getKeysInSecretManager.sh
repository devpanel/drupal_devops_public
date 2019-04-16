#!/bin/bash

#devpanel
#Copyright (C) 2018 devpanel

#This program is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.

#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.

#You should have received a copy of the GNU General Public License
#along with this program.  If not, see <http://www.gnu.org/licenses/>.

set -e

#=== Script Inputs
CLUSTER_NAME=$1
SITE_ID=$2
#=================
aws secretsmanager get-secret-value --region us-east-1 --secret-id /CLUSTER-NAME/$CLUSTER_NAME | jq -r '.SecretString' | jq -r 'to_entries | .[]' | jq -r 'select(.key == "ACCESS_KEY_ID", .key == "SECRET_ACCESS_KEY", .key == "'$SITE_ID'") | .value'
