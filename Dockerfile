FROM python:3.6

COPY scripts /scripts
RUN python -m pip install --upgrade pip
RUN pip install bump2version pyyaml
ENTRYPOINT ["/scripts/run.sh"]
