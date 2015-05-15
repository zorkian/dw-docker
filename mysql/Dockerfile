# This creates a mysql instance
#

FROM       percona:5.5
MAINTAINER Mark Smith "mark@dreamwidth.org"

# Configure timezone
RUN echo "Etc/UTC" > /etc/timezone; dpkg-reconfigure -f noninteractive tzdata

ADD config/my.cnf /etc/mysql/my.cnf
