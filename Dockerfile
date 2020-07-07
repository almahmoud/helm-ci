FROM dtzar/helm-kubectl:3.2.4

RUN apk add git
COPY run.sh /run.sh

ENTRYPOINT ["/run.sh"]
