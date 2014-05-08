#!/bin/bash

MYSQL_COMMAND="mysql -uroot -h $DB_PORT_3306_TCP_ADDR -P $DB_PORT_3306_TCP_PORT"

# Database setup and configuration
echo "CREATE DATABASE dw_schwartz" | $MYSQL_COMMAND
cat $LJHOME/ext/dw-docker/files/theschwartz-schema.sql | $MYSQL_COMMAND dw_schwartz

echo "CREATE DATABASE dw_global" | $MYSQL_COMMAND
$LJHOME/bin/upgrading/update-db.pl -r
$LJHOME/bin/upgrading/update-db.pl -r
$LJHOME/bin/upgrading/update-db.pl -r -p
$LJHOME/bin/upgrading/texttool.pl load

