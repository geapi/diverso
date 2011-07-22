#!/bin/bash

# check number if css files in development mode and warn if too many for IE 8
find . -type f -name '*.css' | wc -l | awk '
{
if ( $1 > 32 )
print "\n###### WARNING ########################################\n  There are " $1 " css files in the project\n  which is above the 32 limit for IE\n#######################################################\n"
else
}'