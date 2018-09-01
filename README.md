![Logo][logo]

# Docker Auto SSL-Certs
A docker container to automatize the certification and renewal of
[Let's Encrypt][1] SSL certificates with the help of [letsencrypt's certbot][3]
and (possibly your own) [lexicon-dns][2].

## Environment Variables
The following table presents a list of variables that you can tweak in order to
modify the container's runtime behaviour. You must supply a value for variables
in a bold font. For the others you can supply a value:

| Variable name | Meaning |
| ---  | --- |
| GITHUB_SLUG | The GitHub repository slug (e.g. astzweig/lexicon) of the [lexcion-dns][2] forkyou want to use. Default: 'analogj/lexicon'. |
| GITHUB_BRANCH | The branch name of a branch in the [lexcion-dns][2] repository you want to use. Default: 'master'. |
| **PROVIDER** | The name of the [lexcion-dns][2] provider you want to use. |

_Note_: You will need to restart the container every time you change one of
these environment variables.

## License
- Licensed under the [EUPL][5].
- Logo: [certification by Creaticca Creative Agency from the Noun Project][4].

[1]: https://letsencrypt.org
[2]: https://github.com/analogj/lexicon
[3]: https://certbot.eff.org
[4]: https://thenounproject.com/term/certification/1660646/
[5]: https://eupl.eu/1.2/en/
[logo]: https://raw.githubusercontent.com/astzweig/docker-letsencrypt-ssl/master/logo.svg?sanitize=true
