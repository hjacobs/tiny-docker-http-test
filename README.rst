===========================
Tiny Docker HTTP Test Image
===========================

Smallest possible Docker image to get a running HTTP server.

.. code-block:: bash

    $ # build a completely static Go binary
    $ CGO_ENABLED=0 go build -a -ldflags '-s' main.go
    $ sudo pip3 install scm-source && scm-source
    $ docker build -t hjacobs/tiny-docker-http-test .
    $ docker run -p 8080:8080 -it hjacobs/tiny-docker-http-test
