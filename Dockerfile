FROM jruby:9.2-jdk

# Necessary for bundler to properly install some gems
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

RUN apt-get update;apt-get install -y git make nodejs

RUN mkdir -p /var/www/findit
COPY . /var/www/findit
RUN gem install bundler
WORKDIR /var/www/findit
RUN bundle install --jobs=4

COPY .docker/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# Start the main process.
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
