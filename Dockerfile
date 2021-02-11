FROM asciidoctor/docker-asciidoctor

LABEL "version"="1.0"

RUN echo "HELLO"

# RUN gem install --no-document asciidoctor-kroki

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

# Tell Puppeteer to skip installing Chrome. We'll be using the installed package.
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Add user so we don't need --no-sandbox.
RUN addgroup -S pptruser && adduser -S -g pptruser pptruser \
    && mkdir -p /home/pptruser/Downloads /app \
    && chown -R pptruser:pptruser /home/pptruser \
    && chown -R pptruser:pptruser /app

COPY --chown=pptruser  ./ /home/pptruser/

RUN wget https://raw.githubusercontent.com/jfrazelle/dotfiles/master/etc/docker/seccomp/chrome.json

# Run everything after as non-privileged user.
USER pptruser

RUN yarn global add @mermaid-js/mermaid-cli

ENV PATH="${PATH}:/home/pptruser/.yarn/bin/"

WORKDIR /home/pptruser

ADD puppeteer-config.json  /puppeteer-config.json

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]