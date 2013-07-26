#!/bin/bash
#
# Designed to be run as part of the Docker setup.
#

echo "CREATE DATABASE dw_schwartz" | mysql -uroot
cat $LJHOME/ext/dw-docker/files/theschwartz-schema.sql | mysql -uroot

echo "CREATE DATABASE dw_global" | mysql -uroot

