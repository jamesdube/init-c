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

  echo "probe -> $1"

  pong=0
  while [ "$pong" != true ]; do

    status=$(curl -L -s -o /dev/null -w '%{http_code}' $1)

    if [ $status -eq 200 ]; then
      echo "Probe successful got $status"
      pong=true
      break
    else
      echo "Probe failed got status ($status), backing off for 5 seconds"
      sleep 5
    fi
  done
}


tcpProbe(){

  host=10.0.0.1
  port=80

  echo "tcp probe"

  while [ "$pong" != true ]; do

    if ( nc -zv $host $port 2>&1 >/dev/null ); then
      echo "Probe successful connected to $host on port $port"
      pong=true
      exit 0
    else
      echo "Probe failed, backing off for 5 seconds"
      sleep 5
    fi

  done

}


#if [ "$1" != "http" ] || [ "$1" != "tcp" ]; then
#  usage
#fi

PROBE=$1

if [ "$PROBE" == "http" ] ; then
  if echo "$2" | grep -Eq "(-u|--u)"; then
       httpProbe $3
    else
      echo "http args"
      usage
      exit 1
  fi
fi

if [ "$PROBE" == "tcp" ] ; then
  if echo "$2" | grep -Eq "(-i|--ip)"; then
       tcpProbe $@
    else
      echo "tcp args"
      usage
      exit 1
  fi
fi

#if [ "$string1" != "$string2" ] && [ "$string3" != "$string4" ] || [ "$bool1" == true ] ; then
#  echo "conditions met - running code ...";
#  else
#    echo "conditions not met"
#fi;
#
#if ping -c1 www.google.com > /dev/null; then
#    echo "It worked"
#else
#    echo "No dice"
#fi