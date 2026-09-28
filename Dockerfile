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

# Install prove6 test runner
RUN zef --/test install App::Prove6
RUN ln -sf /usr/share/perl6/site/bin/prove6 /usr/local/bin/prove6 || true

WORKDIR /app

COPY . /app

# Overwrite the installed Cro::HTTP2::ConnectionState with our HTTP/2 fix.
# zef precompiles Cro into /usr/share/rakudo/site, and that precompiled copy
# takes precedence over the vendored file under /app at load time.
RUN for f in $(grep -rl 'remote-window-consume-queue' /usr/share/rakudo/site/sources 2>/dev/null); do \
        cp /app/Cro/HTTP2/ConnectionState.rakumod "$f"; \
    done \
    && rm -rf /usr/share/rakudo/site/precomp

ARG GIT_HASH=dev
RUN sh -c 'echo "$GIT_HASH" > /app/.git-hash'

CMD ["raku", "-I.", "service.raku"]
