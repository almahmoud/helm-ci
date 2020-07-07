FROM dtzar/helm-kubectl:3.2.4

COPY run.sh /run.sh

ENTRYPOINT ["/run.sh"]
