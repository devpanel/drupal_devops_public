#!/bin/bash

source /importVariables.sh

drush site-install standard install_configure_form.enable_update_status_module=NULL install_configure_form.enable_update_status_emails=NULL --db-url="mysql://$CONTAINER_DB_USERNAME:$CONTAINER_DB_PASSWORD@$RDS_ADDRESS:3306/$CONTAINER_DB_NAME" --site-name="$JENKINS_SITE_TITLE" --account-name="$JENKINS_SITE_ADMIN_USER" --account-pass="$JENKINS_SITE_ADMIN_PASS" --account-mail="$JENKINS_SITE_ADMIN_EMAIL" -y

# Allow upload images
chmod -R 755 /var/www/html
chown -R www-data:www-data /var/www/html

#drush site-install --db-url="mysql://containerbc5cf3c32a86:pass83b18facf275a6b93d128e57c98d89b324dc1072934e6bce@weslei2.chjd06np9gw9.ap-northeast-2.rds.amazonaws.com:3306/mysite" --site-name=$JENKINS_SITE_TITLE --account-name=$JENKINS_SITE_ADMIN_USER --account-pass=$JENKINS_SITE_ADMIN_PASS --account-mail=$JENKINS_SITE_ADMIN_EMAIL -y