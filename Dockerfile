FROM ubuntu:14.04

MAINTAINER Henning Jacobs <henning@jacobs1.de>

COPY resources /resources
RUN chmod 777 /resources
COPY main /main
COPY scm-source.json /

CMD ["/main"]
