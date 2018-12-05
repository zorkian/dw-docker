#!/bin/bash
#
# Designed to be run as part of the Docker setup.
#

# Now replace nginx configuration with our own
rm /etc/nginx/conf.d/default.conf
ln -s /dw-config/*.conf /etc/nginx/conf.d/
