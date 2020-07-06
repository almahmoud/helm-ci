FROM alpine:3.12

RUN apk add curl git
COPY setup.sh /setup.sh
RUN /setup.sh

COPY run.sh /run.sh

ENTRYPOINT ["/run.sh"]
