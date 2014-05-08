#!/bin/bash
#
# Designed to be run as part of the Docker setup.
#

# Now replace some system configuration directories.
rm -rf /etc/apache2
ln -s $LJHOME/ext/local/etc/apache2 /etc/apache2

rm -rf /etc/varnish
ln -s $LJHOME/ext/local/etc/varnish /etc/varnish
