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
ARG USER_HOME=/home/pptruser/
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

RUN mkdir -p /home/pptruser/Downloads /app \
    && chown -R pptruser:pptruser /home/pptruser \
    && chown -R pptruser:pptruser /app


#RUN addgroup -g 101 -S pptruser && adduser -S -g pptruser pptruser \
#    && mkdir -p /home/pptruser/Downloads /app \
#    && chown -R pptruser:pptruser /home/pptruser \
#    && chown -R pptruser:pptruser /app

COPY --chown=pptruser  ./ /home/pptruser/ 

#RUN mkdir -p /dist
#RUN chmod 777 /dist

# Run everything after as non-privileged user.
USER pptruser

RUN yarn global add @mermaid-js/mermaid-cli

ENV PATH="${PATH}:/home/pptruser/.yarn/bin/"

WORKDIR /home/pptruser

ADD puppeteer-config.json  /puppeteer-config.json

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]