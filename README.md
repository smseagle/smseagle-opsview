Opsview-SMS-EAGLE
================

Plugin for Opsview SMS Alerts with use of SMSEagle device (http://www.smseagle.eu)

Script source: https://bitbucket.org/proximus/smseagle-opsview/

Published on BSD License


Installation instructions
-------------------------

#### SMSEAGLE SETUP

Create a new user for this script in SMSEagle.


#### OPSVIEW SETUP

1. Download latest version of Opsview script from: https://bitbucket.org/proximus/smseagle-opsview


2. Edit following lines in the script:

SMSEAGLEIP="192.168.1.101"
SMSEAGLEUSER="john"
SMSEAGLEPASSWORD="doe"


3. Put your script into /usr/local/nagios/plugins/notifications on the Opsview master server.
   Make sure the script is owned by nagios user and is executable. 
   If appropriate, run send2slaves -p to distribute to all slaves.
    
	
4. Create a new Notification Method (Settings > Notification Methods >), and set the appropriate configuration.
   Add value "CONTACTPAGER" in "User Variables" field.


5. Each User will then have to select this Notification Method to one of their Notification Profiles.
   Reload Opsview to make the changes live.

   
6. Test
   Cause a failure to test that the notification is sent.
   After a few seconds, you should receive an SMS.

