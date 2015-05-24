FROM       ubuntu:14.04

RUN apt-get update; apt-get -y install golang
RUN apt-get install -y git
RUN git clone https://github.com/dreamwidth/dw-free.git /dw

ADD scripts/ /opt/

RUN cd /dw/src/proxy; go build

EXPOSE 6250

CMD ["/dw/src/proxy/proxy", "-salt_file=/proxy-salt"]
