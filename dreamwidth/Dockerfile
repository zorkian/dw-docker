# This creates a Dreamwidth development installation.
#

FROM       ubuntu:12.04
MAINTAINER Mark Smith "mark@dreamwidth.org"

# Configuration can go here.
ENV LJHOME /dw

# All this to bootstrap our initialization process so that we can use
ADD files/sources.list /etc/apt/sources.list
RUN apt-get update; apt-get -y install curl fish tmux screen vim snmpd git net-tools iputils-ping

# We pull down the configuration build repository, which will ultimately do
# most of the work for us. We just need Docker to manage the layers and saving
# them at each step of the way to save us some time.
RUN git clone https://github.com/dreamwidth/dw-free.git $LJHOME
RUN git clone https://github.com/xb95/dw-docker.git $LJHOME/ext/dw-docker
RUN git clone https://github.com/dreamwidth/dw-nonfree.git $LJHOME/ext/dw-nonfree

# Configure timezone for later.
RUN echo "Etc/UTC" > /etc/timezone; dpkg-reconfigure -f noninteractive tzdata

# Percona and Varnish signing keys.
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A; gpg -a --export CD2EFD2A | apt-key add -
RUN curl http://repo.varnish-cache.org/debian/GPG-key.txt | apt-key add -

# Continue installing packages. This is done in two steps because we need
# curl to get the Varnish key, so we had to do that first.
RUN apt-get update; apt-get -y install libapreq2-dev apache2-mpm-prefork libapache2-mod-perl2-dev libxml2-dev libgdbm-dev apache2-prefork-dev perlmagick libgtop2-dev libpari-dev libmath-gmp-perl libmath-bigint-perl libmath-bigint-gmp-perl libperl-dev libapache2-request-perl libcrypt-dh-gmp-perl libnet-openid-consumer-perl libnet-openid-server-perl libgd-gd2-perl libgd-graph-perl libdbd-mysql-perl percona-server-client-5.5 perl-doc varnish make libcrypt-dh-perl percona-server-server-5.5

# Set up cpanm and then the modules that Dreamwidth wants.
RUN curl -L http://cpanmin.us | perl - App::cpanminus
RUN cpanm -n -L $LJHOME/extlib/ DateTime::TimeZone Business::CreditCard Cache::Memcached Captcha::reCAPTCHA Class::Accessor Class::Autouse Class::Data::Inheritable Class::Trigger Danga::Socket Data::ObjectDriver DateTime Digest::HMAC_SHA1 Digest::SHA1 Digest::SHA256 File::Type GTop Gearman::Client GnuPG::Interface Hash::MultiValue IO::AIO IO::WrapTie IP::Country::Fast Image::Size LWPx::ParanoidAgent MIME::Lite MIME::Words Mail::GnuPG MogileFS::Client Net::DNS Net::PubSubHubbub::Publisher Proc::ProcessTable RPC::XML SOAP::Lite String::CRC32 Sys::Syscall Template Text::Markdown Text::vCard TheSchwartz TheSchwartz::Worker::PubSubHubbubPublish TheSchwartz::Worker::SendEmail URI::Fetch Unicode::CheckUTF8 Unicode::MapUTF8 XML::Atom XML::RSS XMLRPC::Lite YAML MogileFS::Server MogileFS::Utils Gearman::Server Image::ExifTool

ADD scripts/ /opt/
ADD config/ /dw/ext/local

# setup configs
RUN bash /opt/setup-config.sh

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

EXPOSE 80

ENTRYPOINT ["/usr/sbin/apache2"]
CMD ["-D", "FOREGROUND"]
