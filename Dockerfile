FROM asciidoctor/docker-asciidoctor

LABEL "version"="1.0"

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

COPY --from=pandoc/alpine /usr/local/bin/pandoc /usr/local/bin/

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
        $USER_HOME/Downloads \
        /app \
    && chown -R pptruser:pptruser $USER_HOME \
    && chown -R pptruser:pptruser /app

# Run everything after as non-privileged user.
USER pptruser

RUN yarn global add @mermaid-js/mermaid-cli

COPY --chown=pptruser  ./ $USER_HOME

ENV PATH="${PATH}:$USER_HOME/bin/"

WORKDIR $USER_HOME

ENTRYPOINT ["/home/pptruser/entrypoint.sh"]

CMD ["RUN"]
