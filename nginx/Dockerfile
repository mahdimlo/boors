FROM nginx:latest

RUN apt-get update && \
    apt-get install -y apache2-utils

RUN rm -f /etc/nginx/conf.d/default.conf

ENV USERNAME=admin 
ENV PASSWORD=admin

RUN htpasswd -cb /etc/nginx/.htpasswd "$USERNAME" "$PASSWORD"

COPY nginx.conf /etc/nginx/conf.d/nginx.conf

CMD [ "nginx", "-g", "daemon off;" ]