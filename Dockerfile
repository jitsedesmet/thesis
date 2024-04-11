FROM ruby:3.1.4-bookworm as report-builder
RUN apt-get update && apt-get install -y --no-install-recommends \
    libmagickwand-dev  libssl-dev libffi-dev libyaml-dev zlib1g-dev  \
    && rm -rf /var/lib/apt/lists/*
RUN gem install bundler --version=2.4.22



WORKDIR /app
COPY _papers/thesis-report/Gemfile _papers/thesis-report/Gemfile.lock ./
RUN bundle lock --add-platform aarch64-linux && bundle lock --add-platform x86_64-linux
RUN bundle install --verbose; cat /usr/local/bundle/extensions/x86_64-linux/3.1.0/mini_racer-0.6.3/mkmf.log


COPY _papers/thesis-report .

RUN bundle exec nanoc compile

#FROM ruby:3.1.4 as web-host
#RUN gem install bundler --version=2.4.22
#
#WORKDIR /app
#COPY Gemfile Gemfile.lock ./
#RUN bundle install
#
#COPY . .
#COPY --from=report-builder /app/output /app/solution/storage-guidance-vocabulary/report
#
#EXPOSE 4000
#CMD JEKYLL_ENV=production jekyll serve


#FROM ruby:3.1.4
##RUN apt-get update && \
##    apt-get install -y curl git libssl-dev gcc make libffi-dev libyaml-dev zlib1g-dev build-essential \
##    	ca-certificates curl gnupg netbase sq wget
##
##RUN wget https://cache.ruby-lang.org/pub/ruby/3.2/ruby-3.2.3.tar.gz && \
##    tar -xzvf ruby-3.2.3.tar.gz && \
##    cd ruby-3.2.3 && \
##    ./configure && \
##    make && \
##    make install \
##    cd .. && \
##    rm -rf ruby-3.2.3 ruby-3.2.3.tar.gz
##CMD ruby --version &&\
##    gem --version &&\
##    bundle --version &&\
##    bundle config --global silence_root_warning 1 \
#
##COPY .mise.toml .
##RUN ~/.local/bin/mise --verbose install --verbose
#
##ENV PATH="/root/.local/share/mise/shims:$PATH"
#
##CMD ls /root/.local/share/mise/installs/ruby/3.1.4/
##RUN gem install bundler -v 2.4.22
#
##CMD echo "$PATH" && ls /root/.local/share/mise/shims
#
##CMD ruby --version
##
##RUN bundle config --global frozen 1
##
#WORKDIR /app
#COPY Gemfile Gemfile.lock ./
#RUN bundle install
##
###RUN bundle config build.nokogiri --use-system-libraries
###RUN bundle install
##
##
#COPY . .
##
#EXPOSE 4000
#CMD JEKYLL_ENV=production jekyll serve
##CMD ruby --version
