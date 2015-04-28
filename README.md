# Setup
## Set up mysql containers and Dreamwidth container
    docker run -d --name mysql-data -v /var/lib/mysql -v /var/log/mysql busybox /bin/true
    docker build -t dreamwidth/mysql mysql

    docker build -t dreamwidth/web dreamwidth

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
    # -d : detach and run in background
    # --name dw-web : create an easy-to-remember consistent way to refer to this container
    # -v $LJHOME:/dw : take your repository code (in $LJHOME) and run it inside the container.
                       Any changes you make to files will be reflected immediately.
                       Note: this overrides your config-private.pl to use the docker-specific DB settings
    # --link mysql-db:db : use the mysql database container you created above
    # -p 80:80 : expose port 80 publicly
    # dreamwidth/web : the container name we should use

    docker run -d --name dw-web -v $LJHOME:/dw -it --link mysql-db:db -p 80:80 dreamwidth/web

# Normal operations
## Run
    docker start mysql-db dw-web

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
