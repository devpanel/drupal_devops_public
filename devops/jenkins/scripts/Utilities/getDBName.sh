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



# set -x #echo on
set -e

# ADDRESS=`aws ssm get-parameter --region $REGION --with-decryption --name /ECS-CLUSTER/$CLUSTER/RDS_ADDRESS --output text --query Parameter.Value`
# USERNAME=`aws ssm get-parameter --region $REGION --with-decryption --name /ECS-CLUSTER/$CLUSTER/RDS_ROOT_USERNAME --output text --query Parameter.Value`
# PASSWORD=`aws ssm get-parameter --region $REGION --with-decryption --name /ECS-CLUSTER/$CLUSTER/RDS_ROOT_PASSWORD --output text --query Parameter.Value`

# DUMP_ORIGING_S3_URL=$1
#
#download dump_file:
aws s3 cp ${DUMP_ORIGING_S3_URL} ./SOURCE_SCHEMA.zip
# generate ./SOURCE_SCHEMA.sql:
unzip -p ./SOURCE_SCHEMA.zip > "${f%.zip}SOURCE_SCHEMA.sql"
# SITE_CNAME_ORIGIN=$(cat SOURCE_SCHEMA.sql | grep -oP '(?<=url\.site]=http:\/\/)(.*?)(?=:)' | head -1)
DB_NAME_ORIGIN=$(cat SOURCE_SCHEMA.sql | grep -oP '(?<=Database: ).*' | head -1)
echo $DB_NAME_ORIGIN




#update dump_file:
# OLD_URL=$(cat SOURCE_SCHEMA.sql | grep -oP '(?<=url\.site]=http:\/\/)(.*?)(?=:)')
# sed -i -e "s/$OLD_URL/$NEW_URL/g" snapshot-20181204T094146Z.sql
#
# #params for database connection:
# TABLE="users_field_data";
# # MYSQL_CMD="mysql -P 3306 -h wordpresssdump.cqzfxrjoi6k8.us-west-1.rds.amazonaws.com -u root714b63 -ppass8941acc2f8d60db80af9d598 -e"
# MYSQL_CMD="mysql -P 3306 -h $ADDRESS -u $USERNAME -p$PASSWORD -e"
# MYSQL_CMD_SILENT="mysql -N -s -P 3306 -h $ADDRESS -u $USERNAME -p$PASSWORD $DESTINATION_SCHEMA -e"
# TABLE_EXISTS="select count(*) from information_schema.tables where table_schema='${DESTINATION_SCHEMA}' and table_name='${TABLE}';"
# EXPORT_TABLE="mysqldump -P 3306 -h $ADDRESS -u $USERNAME -p$PASSWORD $DESTINATION_SCHEMA $TABLE"
# DROP_SCHEMA="drop database $DESTINATION_SCHEMA;"
# # FULL_DUMP="mysqldump -P 3306 -h $ADDRESS -u $USERNAME -p$PASSWORD $SOURCE_SCHEMA | mysql --host="$ADDRESS" --user="$USERNAME" --password="$PASSWORD" --database=$DESTINATION_SCHEMA "
# RESTORE_SCHEMA="mysql --host="$ADDRESS" --user="$USERNAME" --password="$PASSWORD" --database=$DESTINATION_SCHEMA < ./SOURCE_SCHEMA.sql"
# DROP_TABLE="drop table $DESTINATION_SCHEMA.$TABLE;"
#
# MYSQL="mysql --host="$ADDRESS" --user="$USERNAME" --password="$PASSWORD" --database="$DESTINATION_SCHEMA" "
# RESTORE_TABLE="cat $TABLE.sql | $MYSQL"
#
# #update DESTINATION_SCHEMA:
#     if [ $($MYSQL_CMD_SILENT "$TABLE_EXISTS") -eq 1 ]; then
#               echo "Table users exists! ..."
#               echo "1-dump table users site B"
#                 $EXPORT_TABLE > $TABLE.sql
#             	echo "2-drop schema site B"
#                 $MYSQL_CMD "$DROP_SCHEMA"
#             	echo "3-re-create schema site B and restore dump site A"
#                 $MYSQL_CMD "create database $DESTINATION_SCHEMA;"
#                 eval $RESTORE_SCHEMA
#             	echo "4-drop users in site B"
#                 $MYSQL_CMD "$DROP_TABLE"
#             	echo "5-restore users in site B"
#                 eval $RESTORE_TABLE
#           else
#               echo "Table users does not exist! ..."
#               eval $RESTORE_SCHEMA
#           fi
