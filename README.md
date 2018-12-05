# Setup
## Set up mysql containers and Dreamwidth container
    docker run -d --name mysql-data -v /var/lib/mysql -v /var/log/mysql busybox /bin/true
    docker build -t dreamwidth/mysql mysql

    docker build -t dreamwidth/web web
    docker build -t dreamwidth/nginx nginx

## Start mysql
Change the password! Note: it's only used here once; everywhere else refers to it using passwords

    docker run --name mysql-db --volumes-from mysql-data -e MYSQL_ROOT_PASSWORD=mysecretpassword -d dreamwidth/mysql


## (FIRST RUN) Setup repo
* Fork repository on Github
* Clone repository onto your computer
* Set your LJHOME variable to where your repository was cloned

## (FIRST RUN) Setup database
    docker run --entrypoint "/bin/bash" -it -v $LJHOME:/dw --link mysql-db:db --rm dreamwidth/web
    > /opt/init-db.sh

## Start Dreamwidth web server
This is not exposed until we run the nginx server below.

    # -d : detach and run in background
    # --name dw-web : create an easy-to-remember consistent way to refer to this container
    # -v $LJHOME:/dw : take your repository code (in $LJHOME) and run it inside the container.
                       Any changes you make to files will be reflected immediately.
                       Note: this overrides your config-private.pl to use the docker-specific DB settings
                       See Configuration section below
    # --link mysql-db:db : use the mysql database container you created above
    # dreamwidth/web : the container name we should use

    docker run -d --name dw-web -v $LJHOME:/dw -it --link mysql-db:db dreamwidth/web

## Start Dreamwidth nginx server
This runs in front of the Apache server and handles serving up static files and HTTPS.

    # -p 80:80 / 443:443 : exposes ports 80 and 443 to the host

    docker run -d --name dw-nginx -v $LJHOME:/dw:ro -it --link dw-web:web -p 80:80 -p 443:443 dreamwidth/nginx-dev


## Optional containers:
### proxy

    docker build -t dreamwidth/proxy proxy
    docker run -d --name dw-proxy -v $LJHOME/ext/local/etc/proxy-salt:/proxy-salt -it dreamwidth/proxy

If you're making changes to the proxy code, you'll want to override the code in `/dw` as well:

    docker run -d --name dw-proxy -v $LJHOME:/dw -v $LJHOME/ext/local/etc/proxy-salt:/proxy-salt --entrypoint "/opt/custom-build.sh" -it dreamwidth/proxy

Running dw-nginx also needs an additional `--link dw-proxy:proxy`:

    docker run -d --name dw-nginx -v $LJHOME:/dw:ro -it --link dw-proxy:proxy --link dw-web:web -p 80:80 -p 443:443 dreamwidth/nginx-dev

Wiki has additional information for [proxy setup](http://wiki.dreamwidth.net/wiki/index.php/Proxy).

# Normal operations
## Run
    docker start mysql-db dw-web dw-nginx

## Stop
    docker stop mysql-db dw-web

## Connecting to your webserver
    curl 127.0.0.1             # not mac
    curl `boot2docker ip`      # mac

# Testing
## Connect to mysql from a test container
    docker run --entrypoint "/bin/bash" -v $LJHOME:/dw -it --link mysql-db:db --rm dreamwidth/web
    mysql -uroot -h $DB_PORT_3306_TCP_ADDR -P $DB_PORT_3306_TCP_PORT -p$DB_ENV_MYSQL_ROOT_PASSWORD

## Attach to dreamwidth web and look around
Commandline prompt doesn't show for the first line, but it's active

    docker attach dw-web

## Detach
Ctrl+p, Ctrl+q

## Look at the webserver logs
    docker exec dw-web tail /var/log/apache2/error.log


# Configuration
The containers will handle connecting between the various containers.

Settings you SHOULD NOT define:

    @LJ::DBINFO, @LJ::THESCHWARTZ_DBS, $LJ::DOMAIN

You'll also want to add `hack.dw`, to your `/etc/hosts` file. Example:

    # standard entries
    127.0.0.1 hack.dw www.hack.dw system.hack.dw

    # services
    127.0.0.1 proxy.hack.dw

    # your test user accounts
    127.0.0.1 testuser.hack.dw some-community.hack.dw


If you're on a Mac, use the result of `boot2docker ip` instead of `127.0.0.1`.
