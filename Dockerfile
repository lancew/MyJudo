FROM alpine:3.24 AS dev

RUN apk add --no-cache gcc git libressl-dev linux-headers make musl-dev perl sqlite-libs

# Install Raku
RUN apk add --no-cache rakudo

# Install zef
RUN apk add --no-cache zef

WORKDIR /app

COPY META6.json .

RUN zef -v install --deps-only --/test .

RUN rm -r /usr/share/perl6/site/bin

# Install prove6 test runner and add it to PATH
RUN zef --/test install App::Prove6 && ln -s /usr/share/perl6/site/bin/prove6* /usr/local/bin/

WORKDIR /app

COPY . /app

CMD ["perl6", "-Ilib", "service.p6"]
