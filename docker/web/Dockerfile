#
# This creates a Dreamwidth webserver.
#

FROM       dreamwidth/base
MAINTAINER Mark Smith "mark@dreamwidth.org"

# Configuration can go here.
# ARG COMMIT=master
ENV COMMIT master

# Things that commands need, but shouldn't change.
ENV LJHOME /dw

# Actually check out the source code now.
RUN git -C $LJHOME fetch && \
    git -C $LJHOME checkout $COMMIT && \
    $LJHOME/bin/build-static.sh

# Copy in support scripts/configurations that are useful.
ADD scripts/ /opt/
ADD config/ /dw/ext/local

# Setup script that runs to make sure we get configs in the right place and do any
# last minute configuration.
RUN bash /opt/setup.sh

# ENV APACHE_RUN_USER www-data
# ENV APACHE_RUN_GROUP www-data
# ENV APACHE_LOG_DIR /var/log/apache2

EXPOSE 80

# Kick off the startup script, which does some healthcheck and then starts
# Apache if things look good.
CMD bash /opt/startup.sh
