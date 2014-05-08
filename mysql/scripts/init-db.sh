#!/bin/bash

# setup database
mysql_install_db

# Setup database user
/usr/bin/mysqld_safe &\
    sleep 3s &&\
    echo "GRANT ALL ON *.* TO root@'%' IDENTIFIED BY '' WITH GRANT OPTION; FLUSH PRIVILEGES" | mysql
