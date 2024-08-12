FROM nginx:latest

RUN apt-get update && \
    apt-get install -y apache2-utils

ENV USERNAME=admin 
ENV PASSWORD=admin

RUN htpasswd -cb /etc/nginx/.htpasswd "$USERNAME" "$PASSWORD"

COPY default.conf /etc/nginx/conf.d/default.conf
COPY materialize.min.css /data/bde-css/materialize.min.css
COPY bde-hadoop.css /data/bde-css/bde-hadoop.css

CMD [ "nginx", "-g", "daemon off;" ]