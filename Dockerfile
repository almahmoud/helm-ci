FROM ubuntu:latest 

COPY scripts /scripts
RUN python -m pip install --upgrade pip
RUN pip install bump2version pyyaml
ENTRYPOINT ["/scripts/run.sh"]
