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
SOURCE_SCHEMA=$1
#=================

cd /tmp
source /importVariables.sh "RDS_ADDRESS ROOT_DB_USERNAME ROOT_DB_PASSWORD"

: ${REGION=`curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r '.region'`}
ACCOUNT_ID=`aws sts get-caller-identity --output text --query 'Account'`
BUCKET_NAME="devops-bucket-${ACCOUNT_ID}-${REGION}"
TIME=`date -u +"%Y%m%dT%H%M%SZ"`

mysqldump --single-transaction -P 3306 -h$RDS_ADDRESS -u$ROOT_DB_USERNAME -p$ROOT_DB_PASSWORD $SOURCE_SCHEMA > snapshot-${TIME}.sql


zip -q snapshot-$TIME.zip snapshot-$TIME.sql -r /var/www/html/sites/default/files -r /var/www/html/modules -r /var/www/html/themes
zip -q -r snapshot-$TIME.zip .
aws s3 cp snapshot-$TIME.zip s3://$BUCKET_NAME/backups/drupal/${CLUSTER_NAME}/${SOURCE_SCHEMA}/snapshot-${TIME}.zip

