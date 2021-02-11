FROM asciidoctor/docker-asciidoctor

LABEL "version"="1.0"

RUN echo "HELLO"

RUN gem install --no-document asciidoctor-kroki

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]