# This creates a mysql instance
#

FROM       ubuntu:12.04
MAINTAINER Mark Smith "mark@dreamwidth.org"

# Configure timezone
RUN echo "Etc/UTC" > /etc/timezone; dpkg-reconfigure -f noninteractive tzdata

RUN apt-get update
RUN apt-get install -y mysql-server

ADD scripts/startup.sh /opt/startup.sh
ADD config/my.cnf /etc/mysql/my.cnf

EXPOSE 3306

ENTRYPOINT ["/opt/startup.sh"]
