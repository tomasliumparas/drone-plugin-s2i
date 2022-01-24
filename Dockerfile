
FROM docker:19.03.8-dind

RUN apk add bash curl git
RUN wget -O - https://github.com/openshift/source-to-image/releases/download/v1.2.0/source-to-image-v1.2.0-2a579ecd-linux-amd64.tar.gz | tar -C /bin -xzvf -

COPY /root/ /

ENTRYPOINT ["/bin/build.sh"]
