#!/bin/bash

# we need to run the setup at startup instead of when building the image
# because it's only at startup that we're linked to a data container

# setup database
mysql_install_db

# Setup database user
/usr/bin/mysqld_safe &\
    sleep 3s &&\
    echo "GRANT ALL ON *.* TO root@'%' IDENTIFIED BY '' WITH GRANT OPTION; FLUSH PRIVILEGES" | mysql

# now start mysqld
/usr/sbin/mysqld