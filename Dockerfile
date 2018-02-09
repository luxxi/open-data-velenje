FROM ruby:2.4.1

RUN apt-get update && \
  apt-get install -qq -y --no-install-recommends build-essential libpq-dev nodejs && \
  rm -rf /var/lib/apt/lists/* && \
  cp /usr/share/zoneinfo/Europe/Ljubljana /etc/localtime

ENV APP_HOME /app

RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/
RUN bundle install

ADD . $APP_HOME
