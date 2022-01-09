FROM nginx
COPY /sites/demo/ /sites/demo
RUN rm /etc/nginx/nginx.conf
COPY /conf/nginx.conf /etc/nginx