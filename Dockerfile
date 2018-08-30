FROM alpine:3.8
LABEL maintainer="it@astzweig.de"
LABEL version="1.0.0-alpha"
LABEL description="A docker container to automatize the certification and \
renewal of Let's Encrypt SSL certificates with the help of letsencrypt's \
certbot and (possibly your own) lexicon-dns."