FROM alpine:3.8
LABEL maintainer="it@astzweig.de"
LABEL version="1.0.0-alpha"
LABEL description="A docker container to automatize the certification and \
renewal of Let's Encrypt SSL certificates with the help of letsencrypt's \
certbot and (possibly your own) lexicon-dns."

COPY ./scripts /root/scripts
RUN for file in /root/scripts/[0-9]*.sh; do \
        chmod u+x "${file}"; \
        "${file}"; \
    done

RUN mv /root/scripts/container-setup.sh /usr/local/bin && \
    chmod u+x /usr/local/bin/container-setup.sh;
CMD ["/usr/local/bin/container-setup.sh"]
