FROM python:3.6-alpine

COPY setup /setup
RUN /setup/setup_helm.sh
RUN /setup/setup_python.sh

COPY scripts /scripts

ENTRYPOINT ["/scripts/run.sh"]
