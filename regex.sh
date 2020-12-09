#!/bin/sh
f=http://google.com

if echo "$f" | grep -Eq "http://*|https://*"; then
    echo '----------regex matches'
    else
      echo "----------regex doest"
fi
verif=$(match "$file" 'https\?://+')
echo $verif
if [[ $verif ]]
then
echo "$f"
echo "respect the template"

else
echo "$f"
echo "doesnt"

fi