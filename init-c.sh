#!/bin/sh

canShift(){
    if [ "$1" != "" ] ; then
        shift # past value
    fi
}

usage() {
    cat << EOF

        USAGE: init-c [PROBE] [ARGS]

        PROBE

          http  Probe for http resources using full url
          tcp   IP and port probe

        ARGS

          -i    IP address for tcp probe
          -p    Port for tcp probe
          -u    The full url for http probe

EOF
exit 1
}


httpProbe(){

    echo "http probe -> $URL"

    if [ -z "${URL}" ] ; then
        echo 'Please set the url eg. -u https://google.com'
        usage
    else
        while true; do

            status=$(curl -L -s -o /dev/null -w '%{http_code}' "$URL")

            if [ "$status" -eq 200 ]; then
                echo "Probe successful got $status"
                exit 0
            else
                echo "Probe failed got status ($status), backing off for 5 seconds"
                sleep 5
            fi
        done
        exit 0
    fi

}

tcpProbe(){

     echo "tcp probe -> $IP:$PORT"

    if [ -z "${IP}" ] || [ -z "${PORT}" ] ; then
        echo "Please set the ip and port eg. -i 127.0.0.1 -p 80"
        usage
    else
        while [ "$pong" != true ]; do

            if ( nc -z "$IP" "$PORT" 2>&1 >/dev/null ); then
              echo "Probe successful connected to $IP on port $PORT"
              pong=true
              exit 0
            else
              echo "Probe failed, backing off for 5 seconds"
              sleep 5
            fi

          done
        exit 0
    fi

}

parseArgs(){

    for arg in "$@"
    do
    case $arg in
        -i|--ip)
            IP="$2"
            shift # past argument
            canShift "$2"
            ;;
        -p|--port)
            PORT="$2"
            shift # past argument
            canShift "$2"
            ;;
        -u|--url)
            URL="$2"
            shift # past argument
            canShift "$2"
            ;;
        --default)
            DEFAULT=YES
            shift # past argument
            ;;
        *)    # unknown option
    #        POSITIONAL+="$1" # save it in an array for later
            shift # past argument
            ;;
    esac
    done
}

parseArgs "$@"

PROBE=$1

if [ "$PROBE" = "http" ]; then
    httpProbe "$@"
fi

if [ "$PROBE" = "tcp" ]; then
    tcpProbe
fi

usage
