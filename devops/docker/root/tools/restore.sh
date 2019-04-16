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
SOURCE_S3_PATH=$1
DESTINATION_SCHEMA=$2
#=================

cd /

source /importVariables.sh "RDS_ADDRESS ROOT_DB_USERNAME ROOT_DB_PASSWORD"


aws s3 cp $SOURCE_S3_PATH snapshot.zip
unzip -o snapshot.zip
cat *.sql | mysql -h$RDS_ADDRESS -u$ROOT_DB_USERNAME -p$ROOT_DB_PASSWORD $DESTINATION_SCHEMA

cd /var/www/html

# Avoids css and js error
drush -y config-set system.performance css.preprocess 0
drush -y config-set system.performance js.preprocess 0
drush cache-rebuild