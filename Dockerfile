FROM python:3.6-alpine3.12

COPY setup setup
RUN setup/setup_helm.sh
RUN setup/setup_python.sh

COPY scripts scripts
WORKDIR scripts

ENTRYPOINT ["./run.sh"]
