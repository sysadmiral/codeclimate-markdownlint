FROM alpine:latest

ENV LANG C.UTF-8

RUN apk add --no-cache \
  build-base \
  git \
  ruby-bundler \
  ruby-dev

WORKDIR /usr/src/app

COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/

RUN bundle

#RUN apt-get update && \
#    apt-get install -y build-essential git && \
#    bundle && \
#    apt-get remove -y build-essential

RUN adduser -u 9000 -D app
COPY . /usr/src/app
RUN chown -R app:app /usr/src/app

USER app

RUN bundle exec rake docs:scrape

VOLUME /code
WORKDIR /code

CMD ["/usr/src/app/bin/codeclimate-markdownlint"]
