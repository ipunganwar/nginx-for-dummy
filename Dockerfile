FROM nginx
COPY /sites/demo/ /sites/demo
RUN rm /etc/nginx/nginx.conf
COPY /conf/nginx.conf /etc/nginx/nginx.conf

RUN mkdir /etc/nginx/ssl
COPY /conf/ssl /etc/nginx/ssl
