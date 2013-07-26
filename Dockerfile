# This creates a Dreamwidth development installation.
#

FROM       ubuntu:12.04
MAINTAINER Mark Smith "mark@dreamwidth.org"

# Configuration can go here.
ENV LJHOME /dw

# We pull down the configuration build repository, which will ultimately do
# most of the work for us. We just need Docker to manage the layers and saving
# them at each step of the way to save us some time.
RUN git clone https://github.com:xb95/dw-docker.git /tmp/docker
RUN cp /tmp/docker/files/sources-local.list /etc/apt/sources.list

# Configure timezone for later.
RUN echo "Etc/UTC" > /etc/timezone; dpkg-reconfigure -f noninteractive tzdata

# Now install a bunch of packages we need to setup the base installation.
RUN apt-get update; apt-get -y install fish tmux screen vim snmpd git curl net-tools iputils-ping

# Percona and Varnish signing keys.
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A; gpg -a --export CD2EFD2A | apt-key add -
RUN curl http://repo.varnish-cache.org/debian/GPG-key.txt | apt-key add -

# Continue installing packages. This is done in two steps because we need
# curl to get the Varnish key, so we had to do that first.
RUN apt-get update; apt-get -y install libapreq2-dev apache2-mpm-prefork libapache2-mod-perl2-dev libxml2-dev libgdbm-dev apache2-prefork-dev perlmagick libgtop2-dev libpari-dev libmath-gmp-perl libmath-bigint-perl libmath-bigint-gmp-perl libperl-dev libapache2-request-perl libcrypt-dh-gmp-perl libnet-openid-consumer-perl libnet-openid-server-perl libgd-gd2-perl libgd-graph-perl libdbd-mysql-perl percona-server-client-5.5 perl-doc varnish

# Reset the APT configuration.
RUN cp /tmp/docker/files/sources.list /etc/apt/sources.list

# Now begin setup for Dreamwidth configuration in /dw.
RUN git clone https://github.com/dreamwidth/dw-free.git $LJHOME
