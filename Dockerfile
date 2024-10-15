FROM ruby:3.1.4

#
WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle install
#
##RUN bundle config build.nokogiri --use-system-libraries
##RUN bundle install
#
#
COPY . .
#
EXPOSE 4000
CMD JEKYLL_ENV=production jekyll serve
#CMD ruby --version
