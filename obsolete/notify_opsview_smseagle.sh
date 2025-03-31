#!/bin/bash
#
# ============================== SUMMARY =====================================
#
# Summary : This plugin sends SMS alerts with SMSEagle hardware sms gateway
# Program : notify_opsview_smseagle.sh
# Version : 1.3
# Date : May, 5, 2016
# Author : Przemyslaw Jarmuzek / SMSEAGLE.EU
# License : BSD
# Copyright (c) 2016, SMSEagle www.smseagle.eu
#
# ============================= SCRIPT ==========================================
#
# Script params description:
# SMSEAGLEIP = IP Address of your SMSEagle device (eg.: 192.168.1.150)
# SMSEAGLEUSER = SMSEagle user
# SMSEAGLEPASSWORD = SMSEagle password
#
### SMSEagle SETUP - please remember to change that settings
SMSEAGLEIP="192.168.1.101"
SMSEAGLEUSER="john"
SMSEAGLEPASSWORD="doe"
#===========================================================#

### Verify if script can work ###
DESTNR=$1
WGET=`which wget`
if [ -z $WGET ]; then
    echo "Wget is required for this method to work. Please install via apt/yum or other package manager"
    exit 1
fi

if [ -z $SMSEAGLEIP ]; then
    echo "This script requires SMSEagle IP address provided, please fill settings above"
    exit 1 
elif [ -z $SMSEAGLEUSER ]; then
	echo "This script requires SMSEeagle username provided, please fill settings above"    
	exit 1
elif [ -z $SMSEAGLEPASSWORD ]; then
        echo "This script requires SMSEeagle password provided, please fill settings above"
        exit 1
elif [ -z $DESTNR ]; then
	echo "This script requires destination number provided, please fill settings above"
	exit 1
fi
#=============================#

### Function for urlencode of SMS text ###
rawurlencode() {
  local string="${TEXT}"
  local strlen=${#string}
  local encoded=""
  local pos c o

  for (( pos=0 ; pos<strlen ; pos++ )); do
     c=${string:$pos:1}
     case "$c" in
        [-_.~a-zA-Z0-9] ) o="${c}" ;;
        * )               printf -v o '%%%02x' "'$c"
     esac
     encoded+="${o}"
  done
  TEXT="${encoded}"
}
#=============================#

### Message content ###
OPSVIEWNAME=`echo -n "$OPSVIEW_NAME"`
NAGIOS_SERVICE=`echo -n "$NAGIOS_SERVICEDESC"`
NAGIOSHOSTNAME=`echo -n "$NAGIOS_HOSTNAME"`
if [ "$OPSVIEWNAME" ];then
	TEXT=`echo -n "$OPSVIEW_OUTPUT"`
elif [ "$NAGIOSHOSTNAME" ]; then
	if [ "$NAGIOS_SERVICE" ]; then
    		TEXT=`echo -n "$NAGIOS_NOTIFICATIONTYPE : $NAGIOS_SERVICEDESC on $NAGIOS_HOSTNAME is $NAGIOS_SERVICESTATE : $NAGIOS_SERVICEOUTPUT $NAGIOS_SHORTDATETIME"`
    	else
    		TEXT=`echo -n "$NAGIOS_NOTIFICATIONTYPE : $NAGIOS_HOSTNAME is $NAGIOS_HOSTSTATE : $NAGIOS_HOSTOUTPUT $NAGIOS_SHORTDATETIME"`
	fi
fi

rawurlencode "$TEXT"
#=============================#

### HTTP API call to send SMS message ###
wget -qO- "http://"${SMSEAGLEIP}"/index.php/http_api/send_sms?login="${SMSEAGLEUSER}"&pass="${SMSEAGLEPASSWORD}"&to="${DESTNR}"&message="${TEXT}""
echo ""

