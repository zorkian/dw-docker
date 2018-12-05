# nginx fronting a DW development installation
# Server certificate and key are public. This is not meant for production.
#

FROM       nginx:1.9

RUN apt-get update; apt-get -y install git

# We pull down the configuration build repository, which will ultimately do
# most of the work for us. We just need Docker to manage the layers and saving
# them at each step of the way to save us some time.
RUN git clone https://github.com/zorkian/dw-docker.git /dw-docker

# Configure timezone for later.
RUN echo "Etc/UTC" > /etc/timezone; dpkg-reconfigure -f noninteractive tzdata

ADD scripts/ /opt/
ADD config/ /dw-config/

# setup configs
RUN /opt/setup-config.sh
