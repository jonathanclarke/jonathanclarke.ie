FROM nginx

EXPOSE 80

COPY _site/ /usr/share/nginx/html
COPY public/ /usr/share/nginx/html
