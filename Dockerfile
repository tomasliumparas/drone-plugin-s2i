
FROM alpine

RUN apk add docker && \
    wget -O - https://github.com/openshift/source-to-image/releases/download/v1.2.0/source-to-image-v1.2.0-2a579ecd-linux-amd64.tar.gz | tar -C /bin -xzvf -


COPY /root/ /

RUN ls /bin

ENTRYPOINT ["build.sh"]
