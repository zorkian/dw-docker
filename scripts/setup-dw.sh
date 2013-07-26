#!/bin/bash
#
# Designed to be run as part of the Docker setup.
#

# Database setup and configuration.
echo "CREATE DATABASE dw_schwartz" | mysql -uroot
cat $LJHOME/ext/dw-docker/files/theschwartz-schema.sql | mysql -uroot dw_schwartz

echo "CREATE DATABASE dw_global" | mysql -uroot
$LJHOME/bin/upgrading/update-db.pl -r
$LJHOME/bin/upgrading/update-db.pl -r
$LJHOME/bin/upgrading/update-db.pl -r -p

# Copies over our configuration directory.
rsync -avPW dw-docker/config/ local

# Now replace some system configuration directories.
rm -rf /etc/apache2
ln -s $LJHOME/ext/local/etc/apache2 /etc/apache2

rm -rf /etc/varnish
ln -s $LJHOME/ext/local/etc/varnish /etc/varnish
