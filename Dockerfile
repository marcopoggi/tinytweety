FROM ruby:3.1-alpine
	
ARG BUILD_PACKAGES="build-base"
ARG DEV_PACKAGES="postgresql-dev nodejs yarn"
ARG RUBY_PACKAGES="bash tzdata git imagemagick"

RUN apk update && apk upgrade && \
    apk add --update --no-cache \
    $BUILD_PACKAGES $DEV_PACKAGES $RUBY_PACKAGES

ENV BUNDLER_VERSION 2.3.20
RUN gem update --system
RUN gem install bundler -v $BUNDLER_VERSION
RUN bundle config set force_ruby_platform true #for platform errors

WORKDIR /app