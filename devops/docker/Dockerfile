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


FROM drupal:8.6.2


#=== Install pre-requisites
RUN apt-get update && \
    apt-get install -y git zip vim wget curl jq zip unzip

#=== Install mysql-client
RUN apt-get install -y mysql-client
    
#====== Install aws-cli
RUN apt-get --reinstall install -y python-minimal && \
    wget https://s3.amazonaws.com/aws-cli/awscli-bundle.zip && \
    unzip awscli-bundle.zip && \
    ./awscli-bundle/install -i /usr/local/aws -b /usr/bin/aws && \
    rm -rf awscli-bundle*
    
#=== Install composer
RUN curl -sS https://getcomposer.org/installer -o composer-setup.php && \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer

#=== Install drush
RUN wget https://github.com/drush-ops/drush/releases/download/8.1.18/drush.phar && \
    chmod +x drush.phar && \
    mv drush.phar /usr/local/bin/drush && \
    drush -v

COPY root/ /
RUN chmod +x /*.sh


CMD /entrypoint.sh