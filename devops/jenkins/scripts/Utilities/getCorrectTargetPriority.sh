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
SITE=$1
#=================

function add()
{
  result=0
  string=$1
  for (( i=0; i<${#string}; i++ ))
  do
    result=$(( $result+`echo -n "${string:$i:1}" | od -An -tuC` ))
  done
  
  echo $result;
}

echo $(( ($(add `echo "$SITE" | md5sum | cut -d " " -f1`) + $(add `echo "$SITE" | sha1sum | cut -d " " -f1`) + $(add `echo "$SITE" | sha256sum | cut -d " " -f1`) + $(add `echo "$SITE" | sha512sum | cut -d " " -f1`) + $(add "$SITE") + ${#SITE}) % 50000 ))