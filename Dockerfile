FROM alpine:3.8
LABEL maintainer="it@astzweig.de"
LABEL version="2.0.0"
LABEL description="A docker container to automatize the certification and \
renewal of Let's Encrypt SSL certificates with the help of letsencrypt's \
certbot and acme-dns."
ARG ACME_DNS_HOOK_URL=https://raw.githubusercontent.com/joohoi/acme-dns-certbot-joohoi/master/acme-dns-auth.py
VOLUME ["/etc/letsencrypt"]

COPY ./scripts /root/scripts
RUN for file in /root/scripts/[0-9]*.sh; do \
        chmod u+x "${file}"; \
        "${file}"; \
    done

RUN cp /root/scripts/[^0-9]*.sh /root/scripts/[^0-9]*.py /usr/local/bin && \
    chmod u+x /usr/local/bin/*.sh /usr/local/bin/*.py && \
    rm /root/scripts/[^0-9]*.sh /root/scripts/[^0-9]*.py;
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/usr/local/bin/container-setup.sh"]
