#!/bin/bash

if ( ! getopts "u:p:s:x:n:c:t:h:i:" opt); then
        echo "Usage: `basename $0` options -u username -p password -x proxy_host_name -n clientname -c contact -t template -h hostname -i ipaddress -s server";
        exit $E_OPTERROR;

fi

while getopts "u:p:s:x:n:c:t:h:i:" opt; do
        case $opt in
                u) USER=$OPTARG;;
                p) PASS=$OPTARG;;
                s) SERV=$OPTARG;;
                x) PROXY_HOST_NAME=$OPTARG;;
                n) CLIENTNAME=$OPTARG;;
                c) CLIENTCONTACT=$OPTARG;;
                t) TEMPLATEID=$OPTARG;;
                h) HOSTNAME=$OPTARG;;
                i) IP=$OPTARG;;
        esac
done

AUTHTOKEN=""
METHOD=""

die () {
  echo $1
  exit $2
}

CURL () {
        EPARAMS=`echo $PARAMS | sed 's/\+/\"/g'`
        curl -k -i -X POST -H 'Content-Type: application/json-rpc' \
          -d "{\"params\": { $EPARAMS }, \"jsonrpc\": \"2.0\", \"method\": \"$METHOD\",\"auth\": \"$AUTHTOKEN\", \"id\": 0}" \
          --user "$USER:$PASS" $SERV/api_jsonrpc.php
}


authenticate() {
        PARAMS="+password+:+$PASS+,+user+:+$USER+"
        METHOD="user.login"
        CURL
}

AUTHTOKEN=$(echo `authenticate` | cut -d'"' -f 8)
if ! [[ "x${#AUTHTOKEN}" == 'x32' ]]; then 
        die "Failed to login into zabbix api" 1 
fi


#
#
# Main
#
HOSTID=""
GROUPID=""


# Get proxy id as HOSTID
METHOD="host.get"
PARAMS="+filter+:{+host+:+$PROXY_HOST_NAME+},+output+:+extend+,+proxy_hosts+:+1+"
HOSTID=$(echo `CURL` | cut -d'"' -f 12)
echo $HOSTID


# Get hostgroup id as GROUPID
METHOD="hostgroup.get"
PARAMS="+filter+:{+name+:+$CLIENTNAME+},+output+:+extend+"
GROUPID=$(echo `CURL`  | cut -d'"' -f 10)
echo $GROUPID

# Create host under group GROUPID accessible via proxy HOSTID
METHOD="host.create"
PARAMS="\
  +host+:+$HOSTNAME+,+proxy_hostid+:+$HOSTID+,\
  +groups+:{+groupid+:+$GROUPID+},\
  +templates+:{+templateid+:+$TEMPLATEID+},
  +inventory+:{+contact+:+$CLIENTCONTACT+},
  +interfaces+:{+type+:+1+,+main+:+1+,+useip+:+1+,+dns+:++,+port+:+10050+,+ip+:+$IP+}"
CURL
