FROM alpine:3.8
LABEL maintainer="it@astzweig.de"
LABEL version="1.1.0"
LABEL description="A docker container to automatize the certification and \
renewal of Let's Encrypt SSL certificates with the help of letsencrypt's \
certbot and (possibly your own) lexicon-dns."
VOLUME ["/lexicon-repo", "/etc/letsencrypt"]

COPY ./scripts /root/scripts
RUN for file in /root/scripts/[0-9]*.sh; do \
        chmod u+x "${file}"; \
        "${file}"; \
    done

RUN cp /root/scripts/[^0-9]*.sh /usr/local/bin && \
    chmod u+x /usr/local/bin/*.sh && \
    rm /root/scripts/[^0-9]*.sh;
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/usr/local/bin/container-setup.sh"]
