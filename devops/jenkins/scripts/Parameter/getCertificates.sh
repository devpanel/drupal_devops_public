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



for REGION in `aws ec2 describe-regions --region=us-east-1 --output text --query 'Regions[*].RegionName'`
do
  RESULT=$RESULT`aws acm list-certificates --region $REGION | jq -r '.CertificateSummaryList | .[] | "'$REGION' : " + .DomainName + " (" + .CertificateArn + ")"'`"\n"
done

echo -e "WITHOUT\n$RESULT" | grep .