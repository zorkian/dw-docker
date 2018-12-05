#!/usr/bin/perl

# Dreamwidth configuration file for use within docker.
# This is for private, site-specific configs (e.g. passwords),
# that are read from the Docker environment.
# Normal configuration should go in your $LJHOME/ext/local/etc directory

{
    package LJ;

    # database info.  only the master is necessary.
    %DBINFO = (
               'master' => {  # master must be named 'master'
                   'host' => $ENV{DB_PORT_3306_TCP_ADDR},
                   'port' => $ENV{DB_PORT_3306_TCP_PORT},
                   'user' => 'root',
                   'pass' => $ENV{DB_ENV_MYSQL_ROOT_PASSWORD},
                   'dbname' => 'dw_global',
                   'role' => {
                       'cluster1' => 1,
                       'slow' => 1,

                       # optionally, apache write its access logs to a mysql database
                       #logs => 1,
                   },
               },

    );

    # Schwartz DB configuration
    @THESCHWARTZ_DBS = (
            {
                dsn =>"dbi:mysql:dw_schwartz;host=$ENV{DB_PORT_3306_TCP_ADDR}",
                user => 'root',
                pass => $ENV{DB_ENV_MYSQL_ROOT_PASSWORD},
            },
        );

    $DOMAIN = "hack.dw";
}
1;
