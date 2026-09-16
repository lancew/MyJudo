# MyJudo

 [![Docker Repository on Quay](https://quay.io/repository/lancew/myjudo/status "Docker Repository on Quay")](https://quay.io/repository/lancew/myjudo)

Judo training tracker website, built with Raku and Cro.

## Building & Running

```
docker-compose up --build
```

Add resources/fake-tls/ca-crt.pem to your browser to avoid self-signed
TLS warnings.

Visit http://localhost and get redirected to https://localhost

## Testing

First install `sqlite3` and make sure by running `sqlite3 --version`
that the one you have is greater than `3.8.3`.

Then install needed modules (including the `prove6` test runner) with:

```
zef install --deps-only --test-depends .
```

Finally run the tests with:

```
prove6 -Ilib t/
```

Or run the tests inside Docker:

```
docker compose run --rm app prove6 -Ilib t/
```

---

Currently running at https://myjudo.net

[Scuttlebutt](https://www.scuttlebutt.nz/) user?, you can also clone this repo via ssb://%MkBUFeRs7fTN2lAUXuYYaK3i9ln29vBisvJnhEcx4KA=.sha256
