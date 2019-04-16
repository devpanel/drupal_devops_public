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


#======= Script Inputs
VARIABLES_TO_IMPORT=$1
#=====================


#==============================================
: ${PATHS_PARAMETER_STORE="/ECS-CLUSTER/$CLUSTER_NAME"}
: ${PATHS_SECRETS_MANAGER="/ECS-CLUSTER/$CLUSTER_NAME /ECS-CLUSTER/$CLUSTER_NAME/SITE/$SITE_ID"}
: ${REGION=`curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r '.region'`}
#==============================================

for PATH_PARAMETER_STORE in $PATHS_PARAMETER_STORE
do
  PARAMETERS_FOUND=`aws ssm describe-parameters --region $REGION | jq -r '.[] | .[] | select(.Name|startswith("'$PATH_PARAMETER_STORE'"))'`
  
  if [ "$PARAMETERS_FOUND" != "" ]
  then
    PARAMETERS=`aws ssm get-parameters-by-path --region $REGION --with-decryption --path $PATH_PARAMETER_STORE`
    VARIABLES_KEYS=`echo "$PARAMETERS" | jq -r '.[] | .[] | .Name|split("/")[-1]'`

    for VARIABLE_KEY in $VARIABLES_KEYS
    do
      if [ "$VARIABLES_TO_IMPORT" == "" ] || [[ "$VARIABLES_TO_IMPORT" =~ "$VARIABLE_KEY" ]]
      then
        VARIABLE_VALUE=`echo "$PARAMETERS" | jq -r '.[] | .[] | select(.Name|endswith("'$VARIABLE_KEY'")) | .Value'`
        eval "export $VARIABLE_KEY='$VARIABLE_VALUE'"
      fi
    done
  fi
done


for PATH_SECRETS_MANAGER in $PATHS_SECRETS_MANAGER
do
  SECRETS_FOUND=`aws secretsmanager list-secrets --region $REGION | jq -r '.SecretList[] | select(.Name == "'$PATH_SECRETS_MANAGER'")'`
  if [ "$SECRETS_FOUND" != "" ]
  then
    SECRETS=`aws secretsmanager get-secret-value --region $REGION --secret-id $PATH_SECRETS_MANAGER | jq -r '.SecretString' | jq -r 'to_entries | .[]'`
    VARIABLES_KEYS=`echo "$SECRETS" | jq -r '.key'`
    
    for VARIABLE_KEY in $VARIABLES_KEYS
    do
      if [ "$VARIABLES_TO_IMPORT" == "" ] || [[ "$VARIABLES_TO_IMPORT" =~ "$VARIABLE_KEY" ]]
      then
        VARIABLE_VALUE=`echo "$SECRETS" | jq -r 'select(.key == "'$VARIABLE_KEY'") | .value'`
        eval "export $VARIABLE_KEY='$VARIABLE_VALUE'"
      fi
    done
  fi
done

# PATHS_SECRETS_MANAGER="/ECS-CLUSTER/weslei2 /ECS-CLUSTER/weslei2/SITE/mysite" REGION=ap-northeast-2 CLUSTER_NAME=weslei2 SITE_ID=mysite ./importVariables.sh 