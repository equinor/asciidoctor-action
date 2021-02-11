FROM asciidoctor/docker-asciidoctor

LABEL "version"="1.0"

RUN echo "HELLO"

# RUN gem install --no-document asciidoctor-kroki

RUN apk add --no-cache npm \
  && cd /root \
  && npm install @mermaid-js/mermaid-cli

ENV PATH="${PATH}:/root/node_modules/.bin"


COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]