#!/bin/sh

usage() {
    echo -e "Usage: init-c [PROBE] [OPTIONS]\n"

    echo -e "PROBE"
    echo -e "  http     \t perform a http request to a given url"
    echo -e "  tcp      \t check if the specified tcp port is open\n"

    echo -e "Options"
    echo -e "  --url    \t (http) the full url"
    echo -e "  --ip     \t (tcp) the target ip address"
    echo -e "  --port   \t (tcp) the target port"
    1>&2; exit 1;
}

httpProbe(){
  if [[ $1 =~ ^http[s]?://[^/]+ ]]; then
    URL=$1
  else
    echo "invalid url : $URL"
  fi
  echo "probe -> $1"
#  for (( ; ; ))
#  do STATUS=$(curl -L -s -o /dev/null -w '%{http_code}' $URL)
#     if [ $STATUS -eq 200 ]; then
#       echo "Probe successful got a $STATUS "
#       break
#      else
#        echo "Probe failed got status -> $STATUS"
#      fi
#      echo "backing off for 5 seconds"
#  done
}


if [ "$1" != "http" ]; then
    usage
fi

PROBE=$1

if [ "$PROBE" == "http" ] ; then
    if [[ "$2" =~ ^("-u"|"--url")$ ]]; then
        httpProbe $3
    else
        echo "$2 is not a supported argument for http probe"
        usage
    fi
fi
