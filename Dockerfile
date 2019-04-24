FROM alpine:latest


WORKDIR /files

COPY original-secret.txt secret.txt
COPY deleted-secret.txt deleted-secret.txt

COPY replaced-secret.txt secret.txt

RUN rm deleted-secret.txt