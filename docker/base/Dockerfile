#
# This creates a Dreamwidth base setup, which has all of the dependencies
# installed. Mostly a speedup hack so we can deploy code changes w/o having
# to rebuild dependencies.
#

FROM       ubuntu:18.04
MAINTAINER Mark Smith "mark@dreamwidth.org"

# Configuration can go here.
# ARG COMMIT=master
ENV COMMIT master

# Things that commands need, but shouldn't change.
ENV LJHOME /dw
ENV DEBIAN_FRONTEND noninteractive

# All this to bootstrap our initialization process so that we can use
RUN apt-get update && \
    apt-get -y install apt-transport-https && \
    apt-get -y install curl fish tmux screen vim snmpd git net-tools \
               iputils-ping git cpanminus curl libssl-dev tzdata && \
    bash -c 'echo "Etc/UTC" > /etc/timezone' && \
    dpkg-reconfigure -f noninteractive tzdata && \
    curl https://raw.githubusercontent.com/dreamwidth/dw-free/master/doc/dependencies-system | \
        xargs apt-get -y install && \
    curl https://raw.githubusercontent.com/dreamwidth/dw-free/master/doc/dependencies-cpanm | \
        xargs cpanm -n -L /dw/extlib/ && \
    rm -rf /var/lib/apt/lists/*

# Actually check out the source code now.
RUN mv $LJHOME/extlib /dw-extlib && \
    rmdir $LJHOME && \
    git clone https://github.com/dreamwidth/dw-free.git $LJHOME && \
    mv /dw-extlib $LJHOME/extlib && \
    git -C $LJHOME checkout $COMMIT

