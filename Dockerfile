FROM python:3.8-slim

RUN apt-get update
RUN pip install --upgrade awscli boto3

WORKDIR /home

COPY create-stack.sh create-stack.sh

ENTRYPOINT []