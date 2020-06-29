FROM python:3.6-slim-buster

COPY scripts /scripts


RUN apt-get update && apt-get install -y apt-transport-https curl gnupg2
RUN curl https://helm.baltorepo.com/organization/signing.asc | apt-key add -
RUN echo "deb https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list
RUN apt-get update && apt-get install -y helm

RUN python -m pip install --upgrade pip
RUN pip install bump2version pyyaml

ENTRYPOINT ["/scripts/run.sh"]
