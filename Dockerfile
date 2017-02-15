FROM ruby:2.3.1

MAINTAINER Jump TV Solutions <contact@jumptvs.com>

RUN apt-get update -qq
RUN apt-get install -y locales

# Set the locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    echo 'LANG="en_US.UTF-8"'>/etc/default/locale && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

ENV LANG en_US.UTF-8

RUN apt-get install -y --no-install-recommends build-essential nodejs zip

ENV INSTALL_PATH /buildpack

RUN mkdir -p $INSTALL_PATH

WORKDIR $INSTALL_PATH

COPY ./cf.Gemfile cf.Gemfile.lock ./
RUN gem install bundler
RUN BUNDLE_GEMFILE=cf.Gemfile bundle install --jobs 4 --retry 3

#VOLUME ["$INSTALL_PATH/public"]