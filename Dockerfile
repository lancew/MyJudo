FROM alpine:3.20.3 AS dev

RUN apk add --no-cache gcc git libressl-dev linux-headers make musl-dev perl sqlite-libs

# Install Perl 6
RUN apk add --no-cache rakudo

# Install zef
RUN apk add --no-cache zef

WORKDIR /app

COPY META6.json .

RUN zef -v install --deps-only --/test .

FROM dev

# Avoid having "binaries" in the final image
RUN rm -r /usr/share/perl6/site/bin

FROM scratch

COPY --from=0 /lib/ld-musl-x86_64.so.1 \
              /lib/libz.*              /lib/
COPY --from=0 /usr/bin/perl6           /usr/bin/
COPY --from=0 /usr/bin/rakudo          /usr/bin/
COPY --from=0 /usr/bin/rakudo-m        /usr/bin/
COPY --from=0 /usr/lib/libmoar.so      \
              /usr/lib/libcrypto.*     \
              /usr/lib/libsqlite3.*    \
              /usr/lib/libssl.*        /usr/lib/
COPY --from=0 /usr/share/nqp           /usr/share/nqp
COPY --from=0 /usr/share/perl6         /usr/share/perl6


WORKDIR /app

COPY . /app

CMD ["perl6", "-Ilib", "service.p6"]
