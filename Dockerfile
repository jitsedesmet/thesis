FROM ruby
LABEL authors="jitsedesmet"

COPY Gemfile Gemfile.lock ./
RUN bundle install

RUN bundle config build.nokogiri --use-system-libraries
RUN bundle install


COPY . .
RUN bundle install
RUN bundle exec jekyll serve --livereload
