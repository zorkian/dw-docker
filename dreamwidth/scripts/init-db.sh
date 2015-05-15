#!/bin/bash

if [[ -n $DB_ENV_MYSQL_ROOT_PASSWORD ]]; then
    MYSQL_COMMAND="mysql -uroot -h $DB_PORT_3306_TCP_ADDR -P $DB_PORT_3306_TCP_PORT -p$DB_ENV_MYSQL_ROOT_PASSWORD"
else
    MYSQL_COMMAND="mysql -uroot -h $DB_PORT_3306_TCP_ADDR -P $DB_PORT_3306_TCP_PORT"
fi

# Database setup and configuration
echo "CREATE DATABASE dw_schwartz" | $MYSQL_COMMAND
cat /dw-docker/dreamwidth/files/theschwartz-schema.sql | $MYSQL_COMMAND dw_schwartz

echo "CREATE DATABASE dw_global" | $MYSQL_COMMAND
$LJHOME/bin/upgrading/update-db.pl -r --innodb
$LJHOME/bin/upgrading/update-db.pl -r --innodb # at least for now we have to run this twice
$LJHOME/bin/upgrading/update-db.pl -r --cluster=all --innodb
$LJHOME/bin/upgrading/update-db.pl -p
$LJHOME/bin/upgrading/texttool.pl load

