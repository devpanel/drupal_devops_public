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
SUBDOMAIN=$1
ONLY_PUBLIC_ZONE=${2-false}
#=================

if [ "${SUBDOMAIN:${#SUBDOMAIN}-1}" != "." ]
then
  SUBDOMAIN=$SUBDOMAIN'.'
fi

if [ "$ONLY_PUBLIC_ZONE" = true ]
then
  for HostedZoneName in `aws route53 list-hosted-zones-by-name | jq -r '.HostedZones | .[] | select(.Config.PrivateZone == false) | .Name'`
  do
    if [[ $SUBDOMAIN =~ .*${HostedZoneName} ]]
    then
      echo $HostedZoneName
      break
    fi
  done
else
  for HostedZoneName in `aws route53 list-hosted-zones-by-name | jq -r '.HostedZones | .[] | .Name'`
  do
    if [[ $SUBDOMAIN =~ .*${HostedZoneName} ]]
    then
      echo $HostedZoneName
      break
    fi
  done
fi

#devops/jenkins/scripts/Utilities/getHostedZoneName.sh "jenkins-client-dev.ezopssoftware.com.br"
