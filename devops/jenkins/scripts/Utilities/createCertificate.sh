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
DOMAIN=$2
HOSTED_ZONE_NAME_IS_ON_CORE_ACCOUNT=${3-no}
#=================


cd `dirname "$0"`
DOMAIN_WITHOUT_TRANSFORM=$DOMAIN

if [ "$HOSTED_ZONE_NAME_IS_ON_CORE_ACCOUNT" == "no" ]
then
  NEW_DOMAIN=*.${DOMAIN#*.}
fi

CERTIFICATE_REQUEST=`aws acm request-certificate --region $REGION --domain-name $DOMAIN --validation-method DNS 2>&1`

if [ $? != 0 ]
then
  CERTIFICATE_ARN=`aws acm request-certificate --region $REGION --domain-name $DOMAIN_WITHOUT_TRANSFORM --validation-method DNS | jq -r '.CertificateArn'`
else
  CERTIFICATE_ARN=`echo "$CERTIFICATE_REQUEST" | jq -r '.CertificateArn'`
fi

if [[ "$CERTIFICATE_REQUEST" =~ .*error.*reached.*limit.* ]]
then
  echo "$CERTIFICATE_REQUEST"
  exit 1
fi

while true
do
  DESCRIPTION=`aws acm describe-certificate --region $REGION --certificate-arn "$CERTIFICATE_ARN"`
  SUBDOMAIN=`echo "$DESCRIPTION" | jq -r '.Certificate | .DomainValidationOptions[0] | .ResourceRecord | .Name'`
  VALUE=`echo "$DESCRIPTION" | jq -r '.Certificate | .DomainValidationOptions[0] | .ResourceRecord | .Value'`

  if [ "$SUBDOMAIN" != "null" ] && [ "$VALUE" != "null" ]
  then
    break
  fi

  sleep 1
done


if [ "$HOSTED_ZONE_NAME_IS_ON_CORE_ACCOUNT" == "yes" ]
then
  AWS_CREDENTIALS=`cat ~/.aws/credentials 2> /dev/null`

  rm -f ~/.aws/credentials
fi

./setSubdomain.sh "$SUBDOMAIN" "$VALUE" > /dev/null

if [ "$HOSTED_ZONE_NAME_IS_ON_CORE_ACCOUNT" == "yes" ] && [ "$AWS_CREDENTIALS" != "" ]
then
  echo "$AWS_CREDENTIALS" > ~/.aws/credentials
fi

while [ "`aws acm describe-certificate --region $REGION --certificate-arn $CERTIFICATE_ARN | jq -r '.Certificate | .Status'`" != "ISSUED" ]
do
  sleep 1
done

echo "$CERTIFICATE_ARN"



# devops/jenkins/scripts/Utilities/configAwsCli.sh AKIAI6LLWQCVDYPRL63A Q9uea4ig1oAM8FmYLCqDSbONoLAFhJ2h6C8+F2q5  # Experiments
# devops/jenkins/scripts/Utilities/configAwsCli.sh AKIAI7ADA2DLXFDBUHZQ Z2rwYBtdbq5lX9S0KIc3KRA8AAmCRVrEHsbCtky7  # Core
# rm -rf ~/.aws
# devops/jenkins/scripts/Utilities/createCertificate.sh eu-central-1 test2018.devpanel.me
