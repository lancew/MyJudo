# MyJudo   [![Build Status](https://travis-ci.org/lancew/MyJudo.svg?branch=master)](https://travis-ci.org/lancew/MyJudo) [![Kritika Analysis Status](https://kritika.io/users/lancew/repos/1285814063416590/heads/master/status.svg)](https://kritika.io/users/lancew/repos/1285814063416590/heads/master/)

This is an experimental website using Rakudo (Rakudobrew) Perl6 and
Bailador. 

First install `sqlite3` and make sure by running `sqlite3 --version`
that the one you have is posterior to `3.8.3`.

Then install needed modules with:

```
zef install --deps-only .
```


And then start the site locally with:
```
bailador watch bin/app.pl6
```

or with
```
bailador --config=host:0.0.0.0,port=3131 easy bin/app.pl6
```

If you want to bind it to any address and run in an alternate server
using the `HTTP::Easy` module for serving. 

You can run tests with:
```
 prove -lv --exec perl6 t
```

Currently running at http://myjudo.net

This app is serving as basis for my November 2017 workshop at the London Perl Workshop on Bailador:

http://act.yapc.eu/lpw2017/talk/7213


