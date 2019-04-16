FROM ruby:2.6.1
ENV app /app

RUN mkdir $app
WORKDIR $app
ADD . $app

RUN bundle install && bundle exec jekyll build

FROM nginx

COPY _site/ /usr/share/nginx/html
COPY public/ /usr/share/nginx/html

EXPOSE 80
