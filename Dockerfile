FROM scratch

MAINTAINER Henning Jacobs <henning@jacobs1.de>

COPY main /main
COPY scm-source.json /

CMD ["/main"]
