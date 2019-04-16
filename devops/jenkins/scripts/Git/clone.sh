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



function urlencode()
{
  local LANG=C i c e=''
  for ((i=0;i<${#1};i++))
  do
    c=${1:$i:1}
    [[ "$c" =~ [a-zA-Z0-9\.\~\_\-] ]] || printf -v c '%%%02X' "'$c"
    e+="$c"
  done
  echo "$e"
}

#=== Script Inputs
GIT_URL=$1
GIT_BRANCH=$2
GIT_USERNAME=$3
GIT_PASSWORD=$4
GIT_FOLDER=${5-`pwd`}
#=================
[[ -d $GIT_FOLDER ]] || mkdir -p $GIT_FOLDER
[[ -d "${GIT_FOLDER}/.git" ]] || git -C $GIT_FOLDER init

REMOTE=${GIT_URL//https\:\/\//https\:\/\/`urlencode $GIT_USERNAME`\:`urlencode $GIT_PASSWORD`\@}
git -C $GIT_FOLDER pull $REMOTE $GIT_BRANCH
