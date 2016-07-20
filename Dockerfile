FROM ruby:2.3.1
# FROM inzinger/alpine-ruby:2.3
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev \
    postgresql-9.4 postgresql-client-9.4 postgresql-contrib-9.4 postgresql-server-dev-9.4

#ENV GEM_PATH /app/ruby/bundle/ruby/2.3.1
#ENV GEM_HOME /app/ruby/bundle/ruby/2.3.1
#RUN mkdir -p ENV GEM_HOME /app/ruby/bundle/ruby/2.3.1
RUN gem install bundler foreman
ENV PATH /usr/local/bundle/bin:$PATH
#ENV BUNDLE_APP_CONFIG /app/ruby/.bundle/config

RUN mkdir -p /app/user
COPY . /app/user
WORKDIR /app/user
RUN bundle install

EXPOSE 4567
CMD ["foreman", "start", "-d", "/app/user", "-f", "/app/user/Procfile", "-p", "4567"]