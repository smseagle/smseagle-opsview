#!/bin/bash
#
# ============================== SUMMARY =====================================
#
# Summary : This plugin sends SMS alerts with SMSEagle hardware sms gateway
# Program : notify_opsview_smseagle.sh
# Version : 1.0
# Date : Apr 01, 2016
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

# Let see if script can work..
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

### Message content ###
TEXT=`echo -n "$NAGIOS_NOTIFICATIONTYPE:$NAGIOS_SERVICEDESC%20on%20$NAGIOS_HOSTNAME%20is%20$NAGIOS_SERVICESTATE:$NAGIOS_SERVICEOUTPUT%20$NAGIOS_SHORTDATETIME"`
#=============================#

# Api call to send SMS message
wget -qO- "http://"${SMSEAGLEIP}"/index.php/http_api/send_sms?login="${SMSEAGLEUSER}"&pass="${SMSEAGLEPASSWORD}"&to="${DESTNR}"&message="${TEXT}""

echo ""
A