![Logo][logo]

# Docker Auto SSL-Certs
A docker container to automatize the certification and renewal of
[Let's Encrypt][1] SSL certificates with the help of [letsencrypt's certbot][3]
and (possibly your own) [acme-dns][2].

## Usage
_Note: Replace '[...]' with all required [enviroment variables][7]._

### Ad-hoc
To try it out juse run:

    $ docker pull astzweig/letsencrypt
    $ cd $HOME;
    $ docker [...] run -v ./certs:/etc/letsencrypt -t -i /etc/periodic/daily/certbot.sh

If successful you can find you certificates inside `$HOME/certs/live`.

### Docker Compose
Inside docker-compose.yml:

```YAML
version: "3.7"
services:
  ssl:
    image: astzweig/letsencrypt
    volumes:
        - ~/certs:/etc/letsencrypt
    environment:
        - EMAIL=your@email.com
        - [...]
```

## Environment Variables
The following table presents a list of variables that you can tweak in order to
modify the container's runtime behaviour. You must supply a value for variables
in a bold font. For the others you can supply a value:

| Variable name | Meaning |
| ---  | --- |
| **EMAIL** | Your email where you want to receive important information regarding your certificates from Let's Encrypt CA. |
| **DOMAINS** | A colon (;) separated list of domain names that you want to get a SSL certificate for. Wildcard domains are supported. If you want multiple domains inside one certificate (SAN certificates) separate the domains with a colon. E.g. 'astzweig.de,sub.astzweig.de;*.example.com'.|
| ACMEDNS_URL | The url to your acme dns server. Default value is: http://acmedns |

_Note_: You will need to restart the container every time you change one of
these environment variables.

## Caveats
- This container will renew certificates automatically every day and overwrite
  the old ones.

## License
- Licensed under the [EUPL][5].
- Logo: [certification by Creaticca Creative Agency from the Noun Project][4].

[1]: https://letsencrypt.org
[2]: https://github.com/joohoi/acme-dns
[3]: https://certbot.eff.org
[4]: https://thenounproject.com/term/certification/1660646/
[5]: https://eupl.eu/1.2/en/
[7]: https://github.com/astzweig/docker-letsencrypt-ssl#environment-variables
[logo]: https://raw.githubusercontent.com/astzweig/docker-letsencrypt-ssl/master/logo.svg?sanitize=true
