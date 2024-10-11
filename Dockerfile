FROM alpine:3.20.3 AS dev

RUN apk add --no-cache gcc git libressl-dev linux-headers make musl-dev perl sqlite-libs

# Install Perl 6
RUN apk add --no-cache rakudo

# Install zef
RUN apk add --no-cache zef

WORKDIR /app

COPY META6.json .

RUN zef -v install --deps-only --/test .

RUN rm -r /usr/share/perl6/site/bin

WORKDIR /app

COPY . /app

CMD ["perl6", "-Ilib", "service.p6"]
