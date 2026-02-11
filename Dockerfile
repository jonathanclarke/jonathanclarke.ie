# Build stage
FROM ruby:4.0.1 AS build

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install --without development

COPY . .
RUN bundle exec jekyll build

# Runtime stage
FROM nginx:stable-alpine

COPY --from=build /app/_site /usr/share/nginx/html
COPY --from=build /app/public /usr/share/nginx/html/public

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
