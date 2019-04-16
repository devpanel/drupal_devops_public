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


#=== Script Inputs
REGION=$1
CLUSTER_NAME=$2
QUERY=${@:3}
#=================

cd `dirname "$0"`

ACCOUNT_ID=`aws sts get-caller-identity --output text --query 'Account'`

../Utilities/runInOneInstanceOnCluster.sh $REGION $CLUSTER_NAME "`aws ecr get-login --no-include-email --region $REGION` && docker pull $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/mysql-client && docker run -e REGION=$REGION -e CLUSTER_NAME=$CLUSTER_NAME $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/mysql-client /query.sh \"$QUERY\""
