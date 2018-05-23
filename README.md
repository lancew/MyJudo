# MyJudo   [![Build Status](https://travis-ci.org/lancew/MyJudo.svg?branch=master)](https://travis-ci.org/lancew/MyJudo) [![Kritika Analysis Status](https://kritika.io/users/lancew/repos/1285814063416590/heads/master/status.svg)](https://kritika.io/users/lancew/repos/1285814063416590/heads/master/)

This is an experimental website using the Perl 6 programming language and Cro.

## Building

```
docker build -t myjudo .
```

## Running

```
docker run -p 80:1080 -p 443:1443 -u "`id -u`:`id -g`" -v $PWD/db:/app/db myjudo
```

Add resources/fake-tls/ca-crt.pem to your browser to avoid scary self signed
warnings.

Visit http://localhost and get redirected to https://localhost

## Testing

First install `sqlite3` and make sure by running `sqlite3 --version`
that the one you have is greater than to `3.8.3`.

Then install needed modules with:

```
zef install --deps-only .
```

Finally run the tests with:

```
prove6 -I=lib -v t/*
```

---

Currently running at https://myjudo.net

This app is serving as basis for my November 2017 workshop at the London Perl Workshop on Bailador:

http://act.yapc.eu/lpw2017/talk/7213

[Scuttlebutt](https://www.scuttlebutt.nz/) user?, you can also clone this repo via ssb://%MkBUFeRs7fTN2lAUXuYYaK3i9ln29vBisvJnhEcx4KA=.sha256
