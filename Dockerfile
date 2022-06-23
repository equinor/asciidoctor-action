FROM pandoc/alpine:2.16.2 AS pandoc
FROM asciidoctor/docker-asciidoctor:1.22.2

LABEL "version"="1.1.1"

# https://github.com/puppeteer/puppeteer/blob/main/docs/troubleshooting.md

# Installs latest Chromium (85) package.
RUN apk add --no-cache \
      chromium \
      nss \
      freetype \
      freetype-dev \
      harfbuzz \
      ca-certificates \
      ttf-freefont \
      nodejs \
      yarn

# Install pandoc
RUN apk --no-cache add \
        gmp \
        libffi \
        lua5.3 \
        lua5.3-lpeg

# "Install" pandoc
COPY --from=pandoc /usr/local/bin/pandoc /usr/local/bin/
## It requires libffi.so.7, but .8 will be installed.
## Using a symbolic link seem to be enough, though if there are issues, we may need
## to copy libffi.so.7, and libffi.so.7.1.0 from `pandoc`
RUN ln -s /usr/lib/libffi.so.8 /usr/lib/libffi.so.7

# Tell Puppeteer to skip installing Chrome. We'll be using the installed package.
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Add user so we don't need --no-sandbox.
ARG USER_HOME=/home/pptruser
ENV USER=pptruser
ENV UID=101
ENV GID=101

RUN addgroup \
    -g "$GID" \
    -S "$USER"

RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "$USER_HOME" \
    --ingroup "$USER" \
    --no-create-home \
    --uid "$UID" \
    "$USER"

RUN mkdir -p \
        $USER_HOME \
        /app \
    && chown -R pptruser:pptruser $USER_HOME \
    && chown -R pptruser:pptruser /app

# Run everything after as non-privileged user.
USER pptruser

# Install all dependencies here, so that the home folder
# can be used directly
WORKDIR /app

COPY --chown=pptruser  package.json .
COPY --chown=pptruser  yarn.lock .
RUN yarn install --frozen-lockfile

COPY --chown=pptruser  ./ .

WORKDIR $USER_HOME

ENV PATH="${PATH}:/app/bin/"

ENTRYPOINT ["/app/entrypoint.sh"]

CMD ["RUN"]
