FROM ruby:3.2.0-alpine3.16

ARG BUILD_PACKAGES="build-base"
ARG DEV_PACKAGES="postgresql-dev vim nodejs"
ARG RUBY_PACKAGES="bash tzdata git imagemagick6 imagemagick6-libs imagemagick6-dev vips-dev"

RUN apk update && apk upgrade && \
  apk add --update --no-cache \
  $BUILD_PACKAGES $DEV_PACKAGES $RUBY_PACKAGES

ENV BUNDLER_VERSION 2.4.7

RUN gem update --system
RUN gem install bundler -v $BUNDLER_VERSION

WORKDIR /app