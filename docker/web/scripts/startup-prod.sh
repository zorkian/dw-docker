#!/bin/bash

set -xe

# Validate that the system is set up and working correctly.
perl -I$LJHOME/extlib/ $LJHOME/bin/checkconfig.pl

# Kick off Apache
cp $LJHOME/ext/local/dreamwidth-prod.conf $LJHOME/ext/local/etc/apache2/sites-enabled/dreamwidth.conf
/usr/sbin/apache2ctl start

# Now wait until... we're killed or other things exit
sleep infinity
