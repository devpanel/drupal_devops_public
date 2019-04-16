#!/bin/bash
# set -e
set -x #echo on


#=== Script Inputs
REGION=$1
CLUSTER_NAME=$2
CONTAINER_DB_NAME=$3
VERSION_IMAGE_INSTALL=$4
# DB_URL=$3
# SITE_TITLE=$4
# ADMIN_USER=$5
# PASS_ADMIN=$6
# EMAIL=$7
#================

cd `dirname "$0"`

ACCOUNT_ID=`aws sts get-caller-identity --output text --query 'Account'`

# ./runInOneInstanceOnCluster.sh $REGION $CLUSTER_NAME "`aws ecr get-login --no-include-email --region $REGION` \
#  && docker pull $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/drupal:img_to_install && docker run --name img_to_install \
#   $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/drupal:img_to_install /install_site.sh && sudo docker cp img_to_install:/var/www/html/. /efs/${SITE_CNAME}/"

./runInOneInstanceOnCluster.sh $REGION $CLUSTER_NAME "`aws ecr get-login --no-include-email --region $REGION` && docker pull $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/drupal:$VERSION_IMAGE_INSTALL && docker run -v /efs/$CONTAINER_DB_NAME:/var/www/html/. $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/drupal:$VERSION_IMAGE_INSTALL /install_site.sh"
